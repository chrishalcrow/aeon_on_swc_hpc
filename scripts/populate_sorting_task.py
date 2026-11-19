# This will populate the sorting tasks

from aeon.dj_pipeline import ephys, spike_sorting
from datetime import timedelta

experiment_name = "abcEphys03-aeon3"
subject = "IAA-1150342"
paramset_id_str = "cjh_406"
sorting_method = "kilosort4"

probe_insertions = (ephys.ProbeInsertion & {'experiment_name': experiment_name}).to_dicts()

################ BLOCKS ##############

block_duration_min = 60*30 # e.g. 60 mins * 30 hours
overlap_min = 60 * 6 # e.g. 60 mins * 6 hours 

chunks = (ephys.EphysChunk & {"experiment_name": experiment_name}).to_dicts()
start_time = min(c["chunk_start"] for c in chunks)
end_time = max(c["chunk_end"] for c in chunks)

block_duration = timedelta(minutes=block_duration_min)
overlap = timedelta(minutes=overlap_min)

advance = block_duration - overlap

blocks = []
i = 0
block_start = start_time
while True:
    block_end = block_start + block_duration
    if block_end > end_time:
        break
    blocks.append((block_start, block_end))
    block_start += advance

for pi in probe_insertions:
    for bstart, bend in blocks:
        block_key = {
            "experiment_name": experiment_name,
            "subject": pi["subject"],
            "insertion_number": pi["insertion_number"],
            "block_start": bstart,
            "block_end": bend,
        }
        ephys.EphysBlock.insert1(block_key, skip_duplicates=True)

total_in_db = len(ephys.EphysBlock & {"experiment_name": experiment_name})

ephys.EphysBlockInfo.populate(display_progress=True, suppress_errors=False)

################ TASKS ##############

for pi in probe_insertions:
    insertion_number = pi["insertion_number"]
    block_rest = {"experiment_name": experiment_name, "insertion_number": insertion_number}
    blocks = (ephys.EphysBlock & block_rest).to_dicts()
    block_info = (
        (ephys.EphysBlockInfo & block_rest).proj("probe_type", "electrode_config_name").to_dicts(limit=1)
    )
    probe_type = block_info[0]["probe_type"]
    electrode_config_name = block_info[0]["electrode_config_name"]
    electrode_groups = spike_sorting.ElectrodeGroup & {'electrode_config_name': electrode_config_name}
    insert_count = 0
    for block in blocks:
        for electrode_group in electrode_groups:
            task_key = {
                "experiment_name": block["experiment_name"],
                "subject": block["subject"],
                "insertion_number": block["insertion_number"],
                "block_start": block["block_start"],
                "block_end": block["block_end"],
                "probe_type": probe_type,
                "electrode_config_name": electrode_config_name,
                "electrode_group": electrode_group["electrode_group"],
                "paramset_id": paramset_id_str,
            }
            spike_sorting.SortingTask.insert1(task_key, skip_duplicates=True)


print(len(spike_sorting.SortingTask & {'experiment_name': experiment_name}))

