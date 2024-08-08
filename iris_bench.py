import subprocess
import signal
import sys
import argparse
import os
import time

gpu_monitor_process = None
benchmark_process = None

def parse_arguments():
    """Parses command-line arguments for the benchmarking script."""
    parser = argparse.ArgumentParser(description='Run GPU monitoring and benchmarking.')
    
    # Add arguments for all the options
    parser.add_argument('--live_monitor', action='store_true', help='Enable live monitoring of GPU metrics.')
    parser.add_argument('--interval', type=int, default=1, help='Interval in seconds for collecting GPU metrics.')
    parser.add_argument('--carbon_region', type=str, default='South England', help='Carbon region for metrics.')
    parser.add_argument('--plot', action='store_true', help='Enable plotting of GPU metrics.')
    parser.add_argument('--live_plot', action='store_true', help='Enable live plotting of GPU metrics.')
    parser.add_argument('--export_to_victoria', action='store_true', help='Export data to VictoriaMetrics.')
    parser.add_argument('--benchmark_image', required=True, help='Benchmark Docker image to use.')
    
    return parser.parse_args()

def set_environment_variables(args):
    """Sets environment variables for Docker based on script arguments."""
    os.environ['BENCHMARK_IMAGE'] = args.benchmark_image

def build_gpu_monitor_command(args):
    """Build the command to run the GPU monitor with the appropriate arguments."""
    command = "gpu_monitor"
    if args.live_monitor:
        command += " --live_monitor"
    if args.interval:
        command += f" --interval {args.interval}"
    if args.carbon_region:
        command += f" --carbon_region {args.carbon_region}"
    if args.plot:
        command += " --plot"
    if args.live_plot:
        command += " --live_plot"
    if args.export_to_victoria:
        command += " --export_to_victoria"
    os.environ['COMMAND'] = command

def run_containers():
    """Start the containers using Docker Compose."""
    subprocess.run(['docker-compose', 'up', '-d'], check=True)

def get_logs(container_name, tail=15):
    """Retrieve the last `tail` lines of logs from the specified Docker container."""
    result = subprocess.run(
        ['docker', 'logs', '--tail', str(tail), container_name],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    return result.stdout.strip().split('\n')

def stop_containers():
    """Stop all containers using Docker Compose."""
    subprocess.run(['docker-compose', 'down'], check=True)

def handle_signal(signum, frame):
    """Handle termination signals."""
    print("\nSignal received. Stopping containers...")
    if gpu_monitor_process:
        gpu_monitor_process.terminate()
    stop_containers()
    sys.exit(0)

def monitor_containers():
    """Monitor the output of both the GPU monitor and benchmark containers."""
    while True:
        #os.system('clear')  # Clear the screen

        # Fetch and display the last 15 lines of GPU monitor logs
        gpu_logs = get_logs('gpu_benchmark_dockerfiles_gpu_monitor_1', tail=15)
        print("\nLive Monitor: GPU Metrics\n")
        print('\n'.join(gpu_logs))
        
        # Fetch and display the last 15 lines of benchmark logs
        benchmark_logs = get_logs('gpu_benchmark_dockerfiles_benchmark_1', tail=15)
        print("\nLive Monitor: Benchmark Output\n")
        print('\n'.join(benchmark_logs))
        
        # Check if benchmark container has finished
        # Check if the benchmark container is still running
        result = subprocess.run(['docker', 'ps', '--filter', f'name=gpu_benchmark_dockerfiles_benchmark_1', '--format', '{{.Names}}'],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if not result.stdout.strip():  # If result is empty, container has stopped
            break
        
        # Sleep for a short while to allow new logs to accumulate
        time.sleep(1)

def main():
    """Main function to start services and display logs."""
    args = parse_arguments()
    set_environment_variables(args)

    # Set up signal handling
    signal.signal(signal.SIGINT, handle_signal)
    signal.signal(signal.SIGTERM, handle_signal)

    build_gpu_monitor_command(args)

    run_containers()
    
    # Monitor both GPU and benchmark container outputs
    monitor_containers()

    # After the benchmark container finishes, stop the gpu_monitor container
    if gpu_monitor_process:
        gpu_monitor_process.terminate()

    # Wait for the gpu_monitor process to terminate and cleanup
    stop_containers()

if __name__ == "__main__":
    main()
