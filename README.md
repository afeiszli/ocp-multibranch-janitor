# Clean Up Your Project

The Janitor will log into your cluster, switch to the specified project,
 and delete objects that are older than a week, 
 saving the specified, space-separated services in the env var $SAVE_THESE_SERVICES

### In your config, specify in the env:
CLUSTER (cluster URL)

USERNAME (user to log in as)

PASSWORD (pass for user)

SAVE_THESE_SERVICES (space separated list of apps you want to keep)
