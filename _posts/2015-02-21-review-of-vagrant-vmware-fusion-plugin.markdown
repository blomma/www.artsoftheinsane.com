Initially I used [VirtualBox][7cba8ed7] to test out [Vagrant][8d3417c4], but it soon became clear that VirtualBox wouldn't cut it on my iMac Retina, it was okay in windowed mode, but fullscreen just killed performance, dragging a window was a exercise in futility. But I had a copy of [VMware Fusion 7][4c067779] installed I knew would work wonders.

But to make VMware Fusion work with Vagrant you need a plugin which you can buy from [https://www.vagrantup.com/vmware][ed373d5a].
As a side note, I like this kind of add-on purchase, especially in this case where it comes with a “30-day, no questions asked, 100% money-back guarantee” as per the [F.A.Q][eded2c21].

Right, so once the plugin is installed you will notice that everything will work pretty much as it did with VirtualBox. I say pretty much, but there are a few caveats.

* The Virtual Machine Library will start to fill with instances of the boxes you use. But vagrant won't remove instances from this view when you destroy a box, so at some point you will need to clean up the dead instances. This is purely cosmetic.
* If you have a multi machine setup where one box has the `.gui = false` set you have to start that box last, otherwise, once you start the box with the gui visible it will also show the other boxes no matter what the setting for `.gui = false` was. This has been reported as [issue#5373][e0b4d942].

But these are minor niggles that in no way detracts from the functionality and with the performance gain I see by using VMware Fusion instead of Virtual Box I can recommend that you plonk down the cash for this plugin.

[eded2c21]: https://docs.vagrantup.com/v2/vmware/installation.html "F.A.Q"
[8d3417c4]: https://www.vagrantup.com "Vagrant"
[7cba8ed7]: https://www.virtualbox.org "VirtualBox"
[4c067779]: http://www.vmware.se/products/fusion "VMware Fusion"
[ed373d5a]: https://www.vagrantup.com/vmware "https://www.vagrantup.com/vmware"
[e0b4d942]: https://github.com/mitchellh/vagrant/issues/5373 "issue#5373"
