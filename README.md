<!--
Faucet README
Based on https://github.com/othneildrew/Best-README-Template
-->



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/InvisaMage/faucet">
    <img src="images/logo.png" alt="Logo" width="200" height="200">
  </a>

  <h1>Faucet</h3>

  <p>
    A script written in Bash which allows you to easily manage a <a href="https://github.com/PaperMC/Waterfall">Waterfall</a> server.
  </p>
</p>

<!-- PROJECT SHIELDS -->
----
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- TABLE OF CONTENTS -->
## Table of Contents

- [Table of Contents](#table-of-contents)
- [About The Project](#about-the-project)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Recommended Usage](#recommended-usage)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://invisamage.com/faucet)

Faucet is a script which allows you to easily manage a [Waterfall](https://github.com/PaperMC/Waterfall) [Minecraft](https://www.minecraft.net/en-us) server.

I found myself manually navigating to the Waterfall website to check for and download new builds. Any repetitive task should be automated and thus Faucet was born.

Faucet can **Backup**, **Trim**, **Update**, and **Start** your Waterfall server.

This was made public in the hopes it's useful to others. Feel free to use this as a template and modify to suit your needs.

<!-- FEATURES -->
## Features
* Install and update [Waterfall](https://github.com/PaperMC/Waterfall)
* Backup the entire server directory to a specified location
* Delete old backups (trim)
* Start the server in a loop (for crash recovery)


<!-- GETTING STARTED -->
## Getting Started

These steps assume you are running a Debian/Ubuntu based distribution of Linux, however, these steps should be similar for all Linux distributions. 
To get a local copy up and running follow these simple steps.

<!-- PREREQUISITES -->
### Prerequisites

Faucet does not have many dependencies. Java packages are different for many distributions, you may need to lookup the package name for flavor of Linux.
* jq
* Java
* curl
```sh
sudo apt install jq openjdk-11-jre curl
```

<!-- INSTALLATION -->
### Installation

1. Clone the repo
```sh
git clone https://github.com/InvisaMage/Faucet.git
```
2. Edit the faucet.conf file to suit your needs
3. Make all the scripts executable
```sh
chmod +x *.sh
```

<!-- USAGE -->
## Usage

Simply run the main script and Faucet will take care of the rest.
```sh
./faucet.sh
```
**Please note, on the first run, you will need to accept the Minecraft EULA manually.**

The other scripts may be run as well, however, they are not well maintained. Use them at your own risk.

<!-- RECOMMENDED USAGE -->
## Recommended Usage
Faucet works best if it's ran using Crontab and screen

Here's an example of a crontab file:
```sh
@reboot cd /home/mc/server && /usr/bin/screen -d -m -h 500 ./faucet.sh
```
This will run Faucet every time the computer reboots and runs it under the screen terminal multiplexer.


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/InvisaMage/faucet/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Travis - support@invisamage.com

Project Link: [https://github.com/InvisaMage/faucet](https://github.com/InvisaMage/faucet)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* Various bash scripting resources
* My Linux Administration teacher
* [Best README Template](https://github.com/othneildrew/Best-README-Template)
* [Terminalizer](https://github.com/faressoft/terminalizer)
* [Text to ASCII Art Generator](https://patorjk.com/software/taag)
* Logo is licensed under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[stars-shield]: https://img.shields.io/github/stars/InvisaMage/faucet?logo=star
[stars-url]: https://github.com/InvisaMage/faucet/stargazers
[issues-shield]: https://img.shields.io/github/issues/InvisaMage/faucet
[issues-url]: https://github.com/InvisaMage/faucet/issues
[license-shield]: https://img.shields.io/github/license/InvisaMage/faucet
[license-url]: https://github.com/InvisaMage/faucet/blob/main/LICENSE.md
[product-screenshot]: images/screensho.gif