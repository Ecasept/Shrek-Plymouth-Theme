# Plymouth Shrek Theme
So you're probably asking yourself what this even is? You know when your computer boots up you usually get your distributions logo and a spinning thing? That screen is managed by a program called [Plymouth](https://en.wikipedia.org/wiki/Plymouth_(software)) (pronounced */ˈplɪməθ/*). You can change this animation using a so called theme.

# Basics
Your themes are located under `/usr/share/plymouth/themes/`.

If you want to add your own theme, you add a new folder there with the name of your theme. Inside of it there needs to be a file called <code>*\<name of your theme\>*.plymouth</code>. (Look at the `shrek.plymouth` file in this theme for an example)

The important property of you `.plymouth` file is the `ModuleName` property. Plymouth has the option of using **plugins/modules** (the attribute calls them modlues but the [source code](https://gitlab.freedesktop.org/plymouth/plymouth) calls them plugins). There are some built-in ones, like `two-splash`, which can be really powerfull, but for creating complex themes you likely want the `script` one.

When using a module, you need to define your module options. For `script`, you need to supply `ImageDir` and `ScriptFile`. This is because the `script` plugin supports a custom programming language. It should be written in `ScriptFile`, and image files you reference from there should be located in `ImageDir`. It is good practice to use these values:
<pre>
ImageDir=/usr/share/plymouth/themes/<i>your theme</i>/
ScriptDir=/usr/share/plymouth/themes/<i>your theme</i>/<i>your theme</i>.script
</pre>

Note: You may need to install the script plugin. On Fedora this can be done using:
```sh
sudo dnf install plymouth-plugin-script
```

# Testing
If you want to install your theme, you need to execute this command.
<pre>
sudo plymouth-set-default-theme -R <i>your-theme</i>
</pre>

This will tell plymouth that you want your theme set as the default theme and `-R` tells it to rebuild the `initrd` (idk what that is, take a look at [the arch wiki](https://wiki.archlinux.org/title/Plymouth#Changing_the_theme) for more info)

This will apply that theme and show it eg. when you boot or shutdown your computer. If you don't want to restart your computer every time you want to test your changes to the theme, Plymouth provides a nice cli to use it:

```sh
# Start the plymouth daemon
sudo plymouthd
# If you want debug output:
# sudo plymouthd --no-daemon --debug

# Show the splash screen
sudo plymouth show-splash

# Show splash screen for 5 seconds
sleep 5

# Hide the splash screen
sudo plymouth hide-splash

# Stop the daemon
sudo plymouth quit
```

**But beware!** This might do some weird stuff with your screen. You can try changing to you default tty with `Ctrl`+`Alt`+`F2`.

Note: If you want to see the output of plymouth when booting, you need to do this:
1. When your computer is booting, go into the grub menu (if it doesn't show up, search on the internet)
2. Press `e` to edit the `Kernel parameters`
3. In the line that starts with `linux`, add `plymouth.debug`
4. Press `Ctrl`+`X` to finish booting your computer
5. Read the log file with `sudo cat /var/log/plymouth-debug.log`

See [the arch wiki](https://wiki.archlinux.org/title/Plymouth#Troubleshooting) for more info.





On my system this didn't work (It would just show the default splash screen with three dots. But it would apply the splash screen correctly when booting) and the debug output didn't help me anymore.

So I took the most sensible approach ever and tried to everything in a VM. For documentation purposes, here are the steps one must take to get a similiar setup to the one I have.

1. Install VirtualBox 7.0
2. Download the Fedora 40 Workstation ISO
3. Create a new Fedora VM
4. Install Fedora on it
5. Don't update the software on it (so don't do `sudo dnf upgrade` to upgrade to the newest packages)
6. Go to Your Fedora VM -> Settings -> Shared Folders
7. Add a new machine folder
    - Folder Path: <code>/home/<i>your host username</i>/VM Shared</code>
    - Folder Name: `VMShared`
    - Mount point: <code>/home/<i>your guest username</i>/VMShared/</code>
    - tick `Auto-mount` and `Make Permanent`
    - Note the difference for `VMShared` on the guest and `VM Shared` on the host
8. Install `plymouth-plugin-script` on your VM
9. Edit the `HOME_DIR` variables in `watch.sh` and `startplymouth.sh` to your users home directory on the VM.

How to use:
- execute `./viewvm.sh` on your computer.
- this will remove `~/VM Shared/shrek`, copy over the new files with `rsync` (install it if needed) and touch `~/VM Shared/touch.txt`
---
- Now the files should be synced to your VM
- in the VM execute `sudo ./VM Shared/shrek/watch.sh`
- this will watch `$HOME_DIR/VMShared/touch.txt` for changes and execute `startplymouth.sh` when changes are noticed.
- `startplymouth.sh` copies over the new theme files to `/usr/share/plymouth/themes/shrek`, restarts the plymouth daemon and shows the splash
---
- now every time when you execute `./viewvm.sh` the files should be copied over to `~/VM Shared`, synced to the VM by VirtualBox, the VM should notice the changes, copy the new files to the themes directory and show the splash.

# Scripting
OK so you've successfully managed to setup the plymouth theme and get the VM setup running (or you had more luck than me and it just worked), how to you program the theme???

Well today is your lucky day because there is actually a bit of [documentation](https://freedesktop.org/wiki/Software/Plymouth/Scripts/) for the language!!!! The [Plymouth website](https://freedesktop.org/wiki/Software/Plymouth/) also has some usefull links, especially [this](https://brej.org/blog/?cat=16) blog post which contains [this](http://brej.org/blog/wp-content/uploads/2010/04/blocks.tar.gz) theme with a script that I extensively analysed to gain more insight into the language's features.

You can also take a look at this theme's code to learn more about what you can do in the scripting language. It feels like a mixture of JavaScript and Python, albeit missing many of the more advanced features of both languages.

TODO: add how to change min length of plymouth splash screen
