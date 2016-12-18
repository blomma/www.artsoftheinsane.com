Work has been in the key of [RoR](http://guides.rubyonrails.org/migrations.html) like migrations, first with [Entity Framework](http://msdn.microsoft.com/en-us/data/ef.aspx) and then with [fluentmigrator](https://github.com/schambers/fluentmigrator), it really beats the pants of trying to keep everything in sync manually. So being inspired by that i thought i give my own code for [Stray](http://stray.artsoftheinsane.com) a good unpack and unhack in the segment of code i use for migration of old data.

Altho i haven’t made all that much in sweeping changes to the data structure there is a few smaller things that has accrued over time and my adhoc migration code is starting to feel the weight of it, but more importantly it was getting harder and harder to actually discern what was going on since the migration code was mixed in with the code that read it.

In Stray i have two things, two structures to account for, one is UserDefaults and the other is our dear old friend CoreData. It would not be the end of the world if i lost track of UserDefaults but why settle and as for CoreData, that would be less good. So for UserDefaults i created a `stateCompatibilityLevel` key which stores the last migration done and for CoreData a Entity called Compatibility was created for the same reason. In the Info.plist i also created a `StrayCompatibilityLevel` which is used for holding the current level of migration.

With that done i moved on to the code, i added a singleton called CompatibilityMigration which gets called in `didFinishLaunchingWithOptions`.

and in that wonderful singleton this little gem resides

	- (void)migrateToCompatibilityLevel:(NSNumber *)toLevel lastCompatibilityLevel:(NSNumber *)lastLevel migrationBlock:(void (^)())migrationBlock {
		// toLevel > lastLevel && toLevel <= appCompatibilityLevel
	    NSNumber *appCompatibilityLevel = [[[NSBundle mainBundle] infoDictionary] objectForKey:STRAY_COMPATIBILITY_LEVEL_KEY];

	    if ([toLevel compare:lastLevel] == NSOrderedDescending && [toLevel compare:appCompatibilityLevel] != NSOrderedDescending) {
	        migrationBlock();
	    }
	}

which i borrowed heavily from [MTMigration](http://https://github.com/mysterioustrousers/MTMigration), the idea being that you call it with a block of code that will perform the migration `ToVersion` and at the same time making sure that we don't reapply the same migration twice. I tweaked it slightly to take `lastVersion` as an argument since i have more than one data store of sorts that i want to migrate.

The actual call to it looks like this

	[self migrateToCompatibilityLevel:@1 lastCompatibilityLevel:[self coredataCompatibilityLevel] migrationBlock:^{
	    NSArray *events = [Event MR_findAll];
	    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	        [obj setGuid:[[NSProcessInfo processInfo] globallyUniqueString]];
	    }];

	    NSArray *tags = [Tag MR_findAll];
	    [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	        [obj setGuid:[[NSProcessInfo processInfo] globallyUniqueString]];
	    }];

	    [self setCoredataCompatibilityLevel:@1];
	}];

The last line

	[self setCoredataCompatibilityLevel:@1];

is there to bump up the CompatibilityLevel after it is done. Also, i opted to make the levels NSNumbers instead of... oh NSStrings, no real reason except for the fact that it was the first things that occurred to me. Notice also the wonderful world of literals as in `@1`, really takes away some of the dreary typing.

All in all, a fairly nice solution since all i have to do the next time i bump `StrayCompatibilityLevel` is to make a new migrationblock .
