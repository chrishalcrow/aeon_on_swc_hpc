# aeon_on_swc_hpc

`aeon_mecha` (https://github.com/SainsburyWellcomeCentre/aeon_mecha/) is a pipelining package for the Aeon project.

This package is designed to make it easy to run `aeon_mecha` specifically on the Sainsbury Wellcome Centre's HPC.

To run the full ephys pipeline there are one-off scripts you need to run. These can be found in aeon_mech and correspond to:

A. Set up experiment, subject, lab room, and the probes used.
B. Add probe configuraations / groups
C. Add the sorting parameter set you want to use

Once these are set up, this repo can be used to run the "daily" stuff. That is

1. Ingest new ephys epoch's and the ephys chunks inside these
2. Add time-blocks (e.g. 30 hour intervals we sort over) and sorting tasks (one task per probe-clump-paramset)
3. Set the sorting tasks running

These three events can be run as

1. `sbatch scripts/ingest_ephys_chunks.sh`
2. `uv run make_blocks_and_tasks.py`
3. `sbatch submit_pipeline.sh`

To help with logging, we add an ordering to the tasks. The tasks are ordered by block index, then insertion number, then probegroup name. E.g. for a set up with 24 hour blocks starting at 00:00:00 Jan 1st, two probe insertions and three groups of electrodes to sort per Probe, the ordering would be

| Task index | Block index | Block start | Block end | Insertion number | Probegroup name |
|---:|---:|---|---|---:|---|
| 0 | 0 | Jan 1 00:00:00 | Jan 2 00:00:00 | 0 | shank1 |
| 1 | 0 | Jan 1 00:00:00 | Jan 2 00:00:00 | 0 | shank2 |
| 2 | 0 | Jan 1 00:00:00 | Jan 2 00:00:00 | 0 | shank3 |
| 3 | 0 | Jan 1 00:00:00 | Jan 2 00:00:00 | 1 | shank1 |
| 4 | 0 | Jan 1 00:00:00 | Jan 2 00:00:00 | 1 | shank2 |
| 5 | 0 | Jan 1 00:00:00 | Jan 2 00:00:00 | 1 | shank3 |
| 6 | 1 | Jan 2 00:00:00 | Jan 3 00:00:00 | 0 | shank1 |
| 7 | 1 | Jan 2 00:00:00 | Jan 3 00:00:00 | 0 | shank2 |
| 8 | 1 | Jan 2 00:00:00 | Jan 3 00:00:00 | 0 | shank3 |
| 9 | 1 | Jan 2 00:00:00 | Jan 3 00:00:00 | 1 | shank1 |
| 10 | 1 | Jan 2 00:00:00 | Jan 3 00:00:00 | 1 | shank2 |
| 11 | 1 | Jan 2 00:00:00 | Jan 3 00:00:00 | 1 | shank3 |

The logs are saved in 

```
slurm_output/{task_index}/{job}_{task_index}_{job_number}.suffix
```

e.g.

```
slurm_output/101/preprocess_101_48756437.err
slurm_output/101/preprocess_101_48756437.out
```


