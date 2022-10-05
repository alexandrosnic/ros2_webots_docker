.PHONY: devel

DISPLAY!=	echo $$DISPLAY
UBUNTU_CODENAME	!=	. /etc/os-release && echo $$UBUNTU_CODENAME
ROS_DISTRO	=	foxy
SRC		!=	realpath ./../../../
UID		!=	id -u

include provision/devel.mk
include provision/docker.mk
include provision/ccbts.mk
include provision/ros2.mk

prod: docker-prepare-prod docker-run-prod docker-logs-prod
devel: docker-prepare-devel docker-run-devel docker-logs-devel

provision-prod: apt-cache ros-apt ros-base ccbts-prod-checkout ccbts-rosdep ccbts-bashrc done
provision-devel: apt-cache ros-apt ros-desktop ccbts-rosdep ccbts-bashrc ccbts-symlink-setup webots vscode done
provision-vnc: apt-cache ccbts-full-checkout provision-devel

apt-cache:
	sudo -E apt-get update

done:
	touch /ccbts/.setup/completed
	@echo "$(tput bold; tput setaf 2)=============================================$(tput sgr0)"
	@echo "$(tput bold; tput setaf 2)Container provisioning completed successfully$(tput sgr0)"
