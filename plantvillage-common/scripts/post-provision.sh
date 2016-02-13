#!/bin/bash

# This script will receive an environment where the
# /plantvillage folder holds the Digits instance, data, models, etc
# /plantvillage-common folder holds all the common scripts

# The current working directory is : /plantvillage-common/scripts

# The environment variable "PLANTVILLAGE_MODE" holds the current running mode
# It could be : "AWS-GPU", "AWS-CPU", "LOCAL"


# Collect & prepare Data
# In this case HRSScene Data
# This should be later replaced with our own dataset
/plantvillage-common/scripts/collect_HRSscene_data.sh
