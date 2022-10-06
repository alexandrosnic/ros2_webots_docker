# Webots and ROS2 Installation docker

A ROS2 Foxy (docker) setup with all the required dependencies for this project (and it will be updated on the go), coupled with Webots simulator R2022a in an Ubuntu 20.04 environment. The setup may work with or without GPU (follow the corresponding guidelines). 

### Prerequisites

Install the following dependencies for your system:

* `git`, `make` and [docker](https://docs.docker.com/engine/install/ubuntu/)
* [docker-compose](https://docs.docker.com/compose/install/)
* [docker-nvidia2](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) if on a **GPU-accelerated system**
* Xserver
    * For Ubuntu: `xhost +local:*` or `xhost +local:docker` (for docker) on Terminal
    * For Mac: e.g. [XQuartz](https://www.xquartz.org/). To install and configure it, follow this [tutorial](https://affolter.net/running-a-docker-container-with-gui-on-mac-os/)
  
### Set Up Docker containing ROS2 & Webots
After completing this section, you are able to run ROS2 and Webots in a docker container.

1) Run docker daemon and add yourself to docker group
    ```sh
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    sudo usermod -aG docker $USER
    ```

1) Start the XServer:
   * For Ubuntu: `xhost +local:*` or `xhost +local:docker` (for docker) on Terminal
   * For Mac: e.g. [XQuartz](https://www.xquartz.org/). To install and configure it, follow this [tutorial](https://affolter.net/running-a-docker-container-with-gui-on-mac-os/). 

1) Create a new workspace `ros_ws` and source `ros_ws/src` directory
    ```sh
    mkdir -p ~/ros_ws/src
    ```
1)  Clone this repository to `ros_ws/src/docker`
    ```sh
    git clone https://github.com/alexandrosnic/ros2_webots_docker.git ~/ros_ws/src/docker
    ```
1) Run provisioning script 
   ```sh
   cd ~/ros_ws/src/docker
   make devel
   ```
1) Wait for the provisioning script to finish
1) Acces the environment from any terminal window
    ```sh
    docker exec -it ccbts-devel bash
    ```
