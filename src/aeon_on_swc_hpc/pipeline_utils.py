import argparse

def pipeline_argparser():

    parser = argparse.ArgumentParser(description="Spike sorting worker")
    parser.add_argument(
        "--task_id", type=int, required=True
    )
    parser.add_argument(
        "--experiment_name", type=str, required=True
    )

    return parser




