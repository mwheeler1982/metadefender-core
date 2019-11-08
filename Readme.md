# metadefender-core

### MetaDefender Core Dockerized For Windows
This should include everything needed to run the MetaDefender Core software in a Windows docker container. This assumes the following:
- Docker host is configured for WCOW (Windows Containers on Windows). See [Docker on windows documentation](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers) for more information.
- Docker host is either Windows 10 or Windows Server 2019, build 1903. You may need to update the [Core Dockerfile](core/Dockerfile) and [Node Dockerfile](node/Dockerfile) to reflect your required version
- Depending on the version of Windows you are running on the Docker host, you can choose between process or hyper-v isolation mode. You may need to modify the [docker-compose.yml](docker-compose.yml) file to change the isolation mode.
  - Windows 10 Pro Host: hyper-v isolation mode is required.
  - Windows Server Host: hyper-v or process isolation mode can be used

##### Getting started
- Clone this repository: `git clone https://github.com/mwheeler1982/metadefender-core.git C:\your\path`
- Create a text file containing your OPSWAT MetaDefender Core activation key, and place it at `core/src/activation.key`
- Optional: modify the [.env](.env) file to specify the version of MetaDefender Core you wish to run
- Optional: modify the [.env](.env) file to specify the number of MetaDefender Core Node instances you wish to run. The default is a single node. 
- Build and start the container: `docker-compose up -d`
- Optional: monitor logs with `docker-compose logs -f` 
- Log in to your vault instance at: http://localhost:8008/ .
  - The default username/password is admin/admin

##### Todo for the future
- Right now, several items are hard-coded:
  - Default admin account credentials
  - Admin account's name and email address
- License is not automatically freed up when container is deleted
- By default, only one node is licensed in the [activation script](core/src/activate.ps1)
- Break out temp and definitions storage into their own volumes