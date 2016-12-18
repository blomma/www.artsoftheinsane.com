So I've been back and forth between [Acorn](http://flyingmeat.com/acorn/) and [Pixelmator](http://www.pixelmator.com/), previously i had a license for Acorn 2 and liked it, but i thought i would give both of them a fair shake. So I've been trying out Pixelmator 2 and Acorn 3, both are nice, Pixelmator has an annoying bug that made it impossible to scroll with an external mouse, they say that they are aware of the issue but had no timeline for the fix, fair enough and not really a deal breaker. What is a deal breaker is the latest update to Pixelmator, 2.0.4, previously they had **Auto Save/Versions** on by default and you could turn it off thru the command line

    defaults -currentHost write com.pixelmatorteam.pixelmator "disableAutosave" -bool YES

I have… opinions about the use of command line settings like this for what is a major feature, in short, don't be lazy and instead expose it thru a proper UI setting, but again, fair enough, the options was there, everyone was happy, you either had your cake or you ate it.

Now in 2.0.4 they introduced something called

> Improved workflow for opening documents (click [here](http://www.pixelmator.com/tutorials/saving-images-2/) to view a short video)

which basically disables **Auto Save/Versions** for every format except the native pxm format. Now this is IMHO a stupendously bad move, that fixes what problem exactly? If you dislike **Auto Save/Versions** why would you want it just on the pxm format and if you like **Auto Save/Versions** why would you want it on just on the pxm format?

It boggles the mind what drove them to come up with this "feature", but thats not all, this also effectively breaks the "Edit with…" command in Aperture. I can open things in Pixelmator from Aperture, but i can't save them back.

Now, not everyone likes the **Auto Save/Versions** feature of Lion, i myself love it to bits, but i can see the other side of the fence on this one. And most apps these days seems to have a way of disabling it, but for the love of Julius Ceasars beard, either you implement it fully or you don't implement it at all. Oh yes, as a part of this new feature they automatically convert the document into pxm native format on open and you have to explicitly export it to save it into another format. Jesus, the more think about it the more i realize how much they borked what was already functioning. And to boot they made it more of a hassle to just open up a picture for a quick edit and then resave, what was once a few simple keystrokes now has to involve the mouse.

In short, a wee bit of a failure there Pixelmator.
