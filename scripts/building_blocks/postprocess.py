from aeon_on_swc_hpc.pipeline_utils import pipeline_argparser

from aeon.dj_pipeline.spike_sorting import PostProcessing, SortingTask

args = pipeline_argparser().parse_args()
task_id = args.task_id
experiment_name = args.experiment_name

sorting_task_key = (SortingTask & {'experiment_name': experiment_name}).to_dicts(order_by='block_start,insertion_number,electrode_group')[task_id]
PostProcessing.populate(sorting_task_key, display_progress=True)
