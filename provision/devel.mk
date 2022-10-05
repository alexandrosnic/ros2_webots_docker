webots:
	wget -nv -O ./webots.deb 'https://github.com/cyberbotics/webots/releases/download/R2022a/webots_2022a_amd64.deb'
	sudo -E apt-get install -y ./webots.deb
	rm -f ./webots.deb
	test -d /ccbts/.config/Cyberbotics || mkdir -p /ccbts/.config/Cyberbotics && rsync -rP ./config/Cyberobotics/ /ccbts/.config/Cyberbotics/

vscode:
	wget -nv -O ./vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
	sudo -E apt-get install -y ./vscode.deb
	rm -f ./vscode.deb
	sudo -E apt-get install -y alsa libxshmfence1 libgtk-3-dev
	test -d /ccbts/cocobots_ws/.vscode || rsync -rP ./config/vscode/ /ccbts/cocobots_ws/.vscode/
	code --install-extension CoenraadS.bracket-pair-colorizer-2
	code --install-extension eamodio.gitlens
	code --install-extension ms-python.python
	code --install-extension ms-vscode.cpptools-extension-pack
	code --install-extension usernamehw.errorlens
