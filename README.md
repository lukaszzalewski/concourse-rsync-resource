# concourse-rsync-resource
[concourse.ci](https://concourse.ci/ "concourse.ci Homepage") [resource](https://concourse.ci/implementing-resources.html "Implementing a resource") for persisting build artifacts on a shared storage location with rsync and ssh.

## Source
* `server`: *Required* Server on which to persist artifacts.
* `port`: *Optional* Server SSH port, default is port 22
* `base_dir`: *Required* Base directory in which to place the artifacts
* `sync_dirs`: *Required* The directories that should be synced between concourse and the remote server
* `user`: *Required* User credential for login using ssh
* `private_key`: *Required* Key for the specified user
### Initial State
If nothing exists a `00000000` directory will be created and used as the initial resource version

## Behaviors

### Check
The `base_dir` is searched for any new version directories that are stored. If versioning is not required the most recent timestamp from the `latest` directory will be used.
### Out
Given a `version` check for its existence and rsync back the artifacts for the
version or the latest directory if versioning is not required.
* `rsync_opts` : *Optional* default `-Pavt`. Any options specified will be added to the defaults
### In
Generate a new `version` number an associated directory in `base_dir` on `server`
using the specified user credential. Rsync across artifacts from the input directory to the server storage location and output the `version` or use the latest directory if versioning is not required and output the most recent file timestamp.
* `rsync_opts` : *Optional* default `-Pavt`. Any options specified will be added to the defaults

###Example

``` yaml
resource_types:
- name: rsync-resource
  type: docker-image
  source:
      repository: mrsixw/concourse-rsync-resource
      tag: latest

resources:
- name: sync-resource
  type: rsync-resource
  source:
    server: server
    base_dir: /sync_directory
    sync_dirs:
      - artifacts1/
      - artifacts2/
    user : user
    private_key: |
            ...

jobs:
- name: my_great_job
  plan:
    ...
    get: sync-resource
      params: 
        rsync_opts: 
        - "-z"
    put: sync-resource
      params: 
        rsync_opts: 
        - "-z"
        - "--del"
        - "--chmod=Du=rwx,Dgo=rx,Fu=rw,Fog=r"
```
