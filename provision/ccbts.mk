ccbts-prod-checkout:
	mkdir -p /ccbts/cocobots_ws/src

ccbts-full-checkout:
	mkdir -p /ccbts/cocobots_ws/src

ccbts-rosdep:
	sudo -E rosdep init
	sudo -E apt-get install -y python3-vcstool
	cd /ccbts/cocobots_ws 
	rosdep --rosdistro ${ROS_DISTRO} update
	cd /ccbts/cocobots_ws && yes | rosdep --rosdistro ${ROS_DISTRO} install -r --from-paths src --ignore-src

ccbts-bashrc:
	sudo -E apt-get install -y bc
	echo 'source /opt/ros/${ROS_DISTRO}/local_setup.bash' >> /ccbts/.bashrc
	ln -sf /ccbts/cocobots_ws/src/ccbts/docker/config/shortcuts.sh /ccbts/.setup/config/shortcuts.sh
	echo 'cd /ccbts/cocobots_ws' >> /ccbts/.bashrc

ccbts-symlink-setup:
	ln -sf /ccbts/cocobots_ws/src/ccbts/docker/Makefile /ccbts/.setup/Makefile
	rm -rf /ccbts/.setup/provision
	ln -sf /ccbts/cocobots_ws/src/ccbts/docker/provision /ccbts/.setup/provision
