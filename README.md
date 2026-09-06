## Samsung Bootloader Bypass

Crack Bit SW REV Check for Samsung Galaxy A32 (A325F) with MT6769T (Downgrade Android 13 > Android 11).

### Preloader (preloader.img):
#### The first code after BROM init.
- [+] Main role: init DRAM, eMMC.
- [+] Checks partition versions via eFuse (also SW REV CHECK).
- [+] Load LK (Little Kernel) / Download Mode (Odin).

`0x338c0` / push {r4-r7, lr} to mov r0, #0 + bx lr (Function for image version check);

`0x3394c` / push {r4-r7, lr} to mov r0, #0 + bx lr (Function for image version check).

Preloader checks the version before LK init. Even if the LK is patched, the preloader blocks the launch, so preloader patch is needed.


### LK - Little Kernel (lk.img):
#### Second stage of load.
- [+] Main role: load Android (boot.img);
- [+] Validates section signatures (vbmeta);
- [+] Implements security policies (PO_CHECK_RP);
- [+] Have get_anti_rollback_ignore - function to disable rollback check.

`0xe721c` / get_anti_rollback_ignore patch mov w0, #1 + ret (Return 'true' / ignore check);

`0x11a5c` / PO_CHECK_RP (handler) to mov r0, #0 + bx lr (Handler for rollback policy).

##### Result:
BROM > Preloader (patch) > LK (patch) > TEE1/TZAR (A11) > boot.img (A11) > System (A11).

![Tutorial](https://github.com/islavikfx/Samsung-Bootloader-Bypass/blob/main/picth/a325ftp.png?raw=true)

### Download mtkclient (Linux):
```
cd ~
sudo apt install -y wget git python3 python3-pip
git clone https://github.com/bkerler/mtkclient.git
cd mtkclient/
git clone https://github.com/islavikfx/Samsung-Bootloader-Bypass.git
sudo pip3 install -r requirements.txt
sudo python3 mtk.py printgpt
```

Full power OFF phone and disconnect USB cable (or disconnect/reconnect battery);

Take the tweezers and close GND to enter EDL (shown in the picture above);

Write: sudo python3 mtk.py printgpt

Connect USB, hold GND until you will see:
```
Port - Device detected :)
Preloader - Detected regular mode !
Preloader - CPU: MT6768/MT6769(Helio P65/G85 k68v1)
Preloader - ...
```
Remove tweezers from GND after device detected (you should see only black screen).

After:
```
// tzar/tee1 from Android 11 (samfw website);
sudo python3 mtk.py w lk Samsung-Bootloader-Bypass/patched_imgs/lk_patched.img
sudo python3 mtk.py w preloader Samsung-Bootloader-Bypass/patched_imgs/preloader_patched.img
sudo python3 mtk.py w tzar tzar.img
sudo python3 mtk.py w tee1 tee1.img
sudo python3 mtk.py reset
```

After:

Disconnect USB, wait 10 secs, hold volume +/-, connect USB and enter Bootloader (Odin Mode);

Flash any OS, even first Android 11 for this model with Odin;

Or you can flash it in EDL if you want to.

FRP erase:

sudo python3 mtk.py e frp

OR sudo python3 mtk.py wo 0x1860000 8388608 /dev/zero (calculate your offset in memory).

See edl_logs.log to check correct memory write, but calculate for your ROM manually.

Preloader must be written with --parttype 1 (boot0) if GPT is empty.

Patched assembly functions in .asm repository files.

Samsung didn't accept this project because bootloader is unlocked :(

Telegram & Discord: @jeddy01759
