eeprom database
------------

BeagleBoard.org BeagleBone (original bone/white):

      A4: [aa 55 33 ee 41 33 33 35  42 4f 4e 45 30 30 41 34 |.U3.A335BONE00A4|]
      A5: [aa 55 33 ee 41 33 33 35  42 4f 4e 45 30 30 41 35 |.U3.A335BONE00A5|]
      A6: [aa 55 33 ee 41 33 33 35  42 4f 4e 45 30 30 41 36 |.U3.A335BONE00A6|]
     A6A: [aa 55 33 ee 41 33 33 35  42 4f 4e 45 30 41 36 41 |.U3.A335BONE0A6A|]
     A6B: [aa 55 33 ee 41 33 33 35  42 4f 4e 45 30 41 36 42 |.U3.A335BONE0A6B|]
       B: [aa 55 33 ee 41 33 33 35  42 4f 4e 45 30 30 30 42 |.U3.A335BONE000B|]

BeagleBoard.org or Element14 BeagleBone Black:

      A5: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 30 30 41 35 |.U3.A335BNLT00A5|]
     A5A: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 30 41 35 41 |.U3.A335BNLT0A5A|]
     A5B: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 30 41 35 42 |.U3.A335BNLT0A5B|]
     A5C: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 30 41 35 43 |.U3.A335BNLT0A5C|]
      A6: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 30 30 41 36 |.U3.A335BNLT00A6|]
       C: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 30 30 30 43 |.U3.A335BNLT000C|]
       C: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 30 30 43 30 |.U3.A335BNLT00C0|]

BeagleBoard.org BeagleBone Blue:

      A2: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 42 4c 41 30 |.U3.A335BNLTBLA2|]

BeagleBoard.org BeagleBone Black Wireless:

      A5: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 42 57 41 35 |.U3.A335BNLTBWA5|]

BeagleBoard.org PocketBeagle:

      A2: [aa 55 33 ee 41 33 33 35  50 42 47 4c 30 30 41 32 |.U3.A335PBGL00A2|]

SeeedStudio BeagleBone Green:

      1A: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 1a 00 00 00 |.U3.A335BNLT....|]
       ?: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 42 42 47 31 |.U3.A335BNLTBBG1|]

SeeedStudio BeagleBone Green Wireless:

     W1A: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 47 57 31 41 |.U3.A335BNLTGW1A|]

Arrow BeagleBone Black Industrial:

      A0: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 41 49 41 30 |.U3.A335BNLTAIA0|]

Element14 BeagleBone Black Industrial:

      A0: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 45 49 41 30 |.U3.A335BNLTEIA0|]

SanCloud BeagleBone Enhanced:

       A: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 53 45 30 41 |.U3.A335BNLTSE0A|]

MENTOREL BeagleBone uSomIQ:

       6: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 4d 45 30 36 |.U3.A335BNLTME06|]
       
Neuromeka BeagleBone Air:

      A0: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 4e 41 44 30 |.U3.A335BNLTNAD0|]

Embest replica?:

          [aa 55 33 ee 41 33 33 35  42 4e 4c 54 74 0a 75 65 |.U3.A335BNLTt.ue|]

GHI OSD3358 Dev Board:

     0.1: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 47 48 30 31 |.U3.A335BNLTGH01|]

PocketBone:

       0: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 42 50 30 30 |.U3.A335BNLTBP00|]

Octavo Systems OSD3358-SM-RED:

       0: [aa 55 33 ee 41 33 33 35  42 4e 4c 54 4F 53 30 30 |.U3.A335BNLTOS00|]

BeagleLogic Standalone:

       A: [aa 55 33 ee 41 33 33 35  42 4c 47 43 30 30 30 41 |.U3.A335BLGC000A|]

Scripts to support customized image generation for many arm systems

BeagleBoard branch:
------------

    git clone https://github.com/beagleboard/image-builder.git

Release Process:

    bb.org-v201Y.MM.DD
    git tag -a bb.org-v201Y.MM.DD -m 'bb.org-v201Y.MM.DD'
    git push origin --tags

Master branch:
------------

    git clone https://github.com/RobertCNelson/omap-image-builder

eewiki.net: Debian Stable (armel) minfs:

    ./RootStock-NG.sh -c eewiki_minfs_debian_stretch_armel

eewiki.net: Debian Stable (armhf) minfs:

    ./RootStock-NG.sh -c eewiki_minfs_debian_stretch_armhf

elinux.org: Debian Images:

    ./RootStock-NG.sh -c rcn-ee_console_debian_stretch_armhf
    ./RootStock-NG.sh -c rcn-ee_console_debian_buster_armhf
    http://elinux.org/BeagleBoardDebian#Demo_Image

elinux.org: Ubuntu Images:

    ./RootStock-NG.sh -c rcn-ee_console_ubuntu_bionic_armhf
    http://elinux.org/BeagleBoardUbuntu#Demo_Image

Release Process:

    vYEAR.MONTH
    git tag -a v201y.mm -m 'v201y.mm'
    git push origin --tags

MachineKit:
------------

    ./RootStock-NG.sh -c machinekit-debian-jessie
    http://elinux.org/Beagleboard:BeagleBoneBlack_Debian#BBW.2FBBB_.28All_Revs.29_Machinekit
