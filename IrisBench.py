import argparse
import subprocess
import os
import time

def parse_arguments():
    """Parse command-line arguments for configuring gpu_monitor and selecting benchmark container."""
    parser = argparse.ArgumentParser(description='Run gpu_monitor and benchmark containers.')
    parser.add_argument('--live_monitor', action='store_true', help='Enable live monitoring of GPU metrics.')
    parser.add_argument('--interval', type=int, default=1, help='Interval in seconds for collecting GPU metrics.')
    parser.add_argument('--carbon_region', type=str, default='South England', help='Carbon region for data collection.')
    parser.add_argument('--plot', action='store_true', help='Enable plotting of GPU metrics.')
    parser.add_argument('--live_plot', action='store_true', help='Enable live plotting of GPU metrics.')
    parser.add_argument('--export_to_victoria', action='store_true', help='Enable exporting data to VictoriaMetrics.')
    parser.add_argument('--benchmark_image', required=True, help='Docker image for the benchmark container.')
    return parser.parse_args()

def set_environment_variables(args):
    """Set environment variables for gpu_monitor and benchmark selection."""
    os.environ['LIVE_MONITOR'] = str(args.live_monitor).lower()
    os.environ['INTERVAL'] = str(args.interval)
    os.environ['CARBON_REGION'] = args.carbon_region
    os.environ['PLOT'] = str(args.plot).lower()
    os.environ['LIVE_PLOT'] = str(args.live_plot).lower()
    os.environ['EXPORT_TO_VICTORIA'] = str(args.export_to_victoria).lower()
    os.environ['BENCHMARK_IMAGE'] = args.benchmark_image

def run_containers():
    """Run the containers using Docker Compose."""
    subprocess.run(['docker-compose', 'up', '--build', '-d'], check=True)

def get_logs(service):
    """Get the logs for a specific Docker service."""
    return subprocess.Popen(['docker-compose', 'logs', '-f', service], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

def print_formatted_output(log_streams):
    """Format and print logs from multiple streams."""
    while True:
        for service, log_stream in log_streams.items():
            line = log_stream.stdout.readline()
            if line:
                if service == "gpu_monitor":
                    print("\nLive Monitor: GPU Metrics\n")
                    print(line.strip())
                elif service == "benchmark":
                    print("\nLive Monitor: Benchmark Output\n")
                    print(line.strip())
        time.sleep(1)

def main():
    """Main function to start services and display logs."""
    args = parse_arguments()
    set_environment_variables(args)

    run_containers()

    log_streams = {
        "gpu_monitor": get_logs("gpu_monitor"),
        "benchmark": get_logs("benchmark")
    }

    try:
        print_formatted_output(log_streams)
    except KeyboardInterrupt:
        print("\nStopping services...")
        subprocess.run(['docker-compose', 'down'], check=True)
    finally:
        for stream in log_streams.values():
            stream.terminate()

if __name__ == "__main__":
    main()
