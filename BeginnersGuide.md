# Beginners Guide

We are coming up to RailsGirlsSummerOfCode, so i wrote this document for people with
very little coding or ruby experience. It can be used by other people as a check-list,
because basically anything in here is assumed when working on RubyX.

# Tools of the trade

I just want to introduce the main characters, what you need, maybe some extra.
Details for installing or using software are abound on the net, so i am not getting
into specifics, platform issues or the like. Just an overview that you may not find
on the net.

## Terminal

The terminal and editor are still the two main tools you need. A terminal is a program
that interprets typed input and starts other programs. The interpreters are called
shells, bash (Bourne Again SHell) is popular, but anything you have is fine.

The shell starts when you start a terminal (window or tab) and usually reads somehting
like .profile, or .bash_profile , where environment variables may be set. These
variables, usually with capital names, influence the behaviour of programs. The most
import one is probably the PATH variable, that determines where program executables
are searched.

Don't fuss in the beginning which terminal you use, anything is fine for starters.

When i talk about commands, i mean typing those commands in the terminal.

## Editor

Off course you need an editor to edit program files. The most important thing here is
that it supports colour highlighting for ruby. It may be an IDE like RubyMine, vim, or
i use atom. It does not really matter, as long as you know how to use it.  

## Ruby, maybe with versions

There are two main ruby implementations, called MRI (Matz Ruby implementations) and
JRuby (Java Ruby), we will use MRI.

There are several versions of MRI, though that used to matter more than it does now.
Anything over 2.4 is fine for RubyX.

Because version differences were bigger, and in a professional environment it is
essential to know the exact version on is using (in development and production)
ruby version managers have been developed. There are rbenv and rvm , but since
you don't really need them i will leave it at that.

## Gems

Gems are packages of ruby code. After all, any meaningful software will rely on other
software, and so gems have been with ruby from the start as a way of packaging code.

Eg rubyx is a gem, and you can see the package definition in rubyx.gemspec in the root
folder.

gem is also a command to manage gems. A version of gem (the command) will come with
any ruby installation. gem is used to manage single packages, but for a project
we usually need many gems, and this is where bundler comes in.

## Bundler

Bundler is a program (a gem actually) to manage all the gems a project needs. The
problem it was made to solve is this: Say you need 10 gems for a project. Those 10
gems all have dependencies of their own, so really you may need 20-40 gems.
If not managed, different developers and production systems will have slightly
different versions of gems. This leads to very hard to track errors, a nightmare
basically.

A Gemfile is the bundlers way of specifying a projects dependencies. Bundler
(using the command bundle install) then resolves all dependencies and their
dependencies and installs all the needed gems.

Bundler also creates a Gemfile.lock to record all the gems that are needed. This file
is usually checked in and will ensure that every developer has the same gems.

Only when the Gemfile is changed, or one wants to update gems by hand, does bundle
install need to be run again.

## Git

Version control has always been essential to coordinate the work of many people,
and git is arguably the best tool for the job. So you need to install it and get
to know the basics, at least clone, commit, push, and basic branches.

After installing MRI and bundler you need to clone the rubyx repository.
Go to the  directory and bundle (or bundle install, sama sama)

Then you can run "ruby test/test_all.rb" to determine that everything is working as it
should. If it does, you are ready to start development.

# Development process

Once you have a working environment, you'll be wanting to code. So this section is
about the basic loops we go through as developers, the recurring tasks that make
up a programmers life. I'll try to avoid jargon and rather explain why we do what we do.

## Edit => Save

The most basic cycle is undoubtedly edit and save. You edit some part of the program
and save your work. There are some details to consider about the formatting and style,
in the [Code Style](CodeStyle.md).

There are two basic needs to do this basic coding:
- you need to know what to edit, what it is you want to achieve and how to achieve it
- having finished (saved) you  need a way to know if you have achieved what you set out to do

The "how to achieve it" part is the skill of programming. Like all skills, developing
this skill is a process and takes years, so i'll leave it at that.

What you want to achieve is up to you. Your imagination for the new. Your ability to
find bugs. Or your willingness to do what others have found worthy of doing (issues).
This is explained more in the next section.

So then we come to that crucial part of knowing when you achieved your goal. This has
been at the crux of programming since the dawn, and the most widely agreed upon way is
off course testing. Everybody agrees testing is the way, just how much is in dispute.
It's like being healthy: everybody agrees in principle, but many still smoke, or
eat meat or milk products (clearly shown to be unhealthy)

## Testing (or edit => save => test)

RubyX is very clear on the topic: all code needs tests. All new code needs new test.
Every bug-fix needs more tests. Tests are the only way we know things work, and
since RubyX produces programs as it's output (which should run correctly), we need
to know doubly well that everything works. Both the RubyX code, and the generated code,
must work, ie be tested. Some may call this TDD extreme, i call it common sense, and
find it is the best way to work.

Specifically RubyX uses minitest, and has several layers of tests under the test
directory. Generally speaking, test files contain ruby code called tests.
This code exercises the source code and asserts (tests)
assumptions to be correct. Minitest provides a base Test class to derive from and
about ten different assert methods to assert assumptions. Methods of the class must
start with test_ and each such method is called a test.

RubyX currently has over 1700 tests with almost 15000 assertions.
At about 7k lines of code, that is roughly 2 assertion for each line of code. this
should give you an idea how important testing is in RubyX.

## Automated testing (edit, save , autotest) or guard

Guard is a tool to run tests automatically. Similarly to bundler, Guard defines
a Guardfile to define which tests should be run, and a command-line tool (guard)
to run them automatically.

Basic tests mirror the same directory structure as the code in the test
directory. Basic (or unit) tests live in files with the same name as the source
code file name, with a "test_" prefix, in a shadowed directory. Eg for a file
/lib/parfait/word.rb , there will be a file in /test/parfait/test_word.rb .

The Guardfile defines conventions like this, in code. So there
is a basic rule in the Guardfile  stating that when a source file changes
the equivalent test file should be run. Other rules may be added easily,
as a Guardfile is really just ruby code, working against the guard api.

The way to use guard is to have a terminal open and start the guard command.
Guard will listen for changes, and once a file is saved *automatically* run
affected test files.

This way we're back to edit, save, the shortest possible loop. Only when all tests
are green, and there are enough (new) tests to cover the code, can you move on to the
next phase, sharing your code.

# Contribution process

Open source is all about sharing code. It maybe for the greater good, or just fun,
but it is working together in a coordinated fashion. Git (with commit rights) is
what makes the coordination easy, some might say possible.

You start with a clean environment, either you just cloned, or pulled from github.

There are several ways to find what you want to work on, but all roads lead to
github issue. You either find an existing one, or create one. Don't start
work on something that has no issue, and the best way is to make your intention
clear, by commenting on the issue.

## Topic branches and issues

Once you have a topic (and a github issue to go with it) you want to start coding.
But don' just yet. To manage you changes with others, it is best to create what is called a topic branch. Branches are very cheap in git (very little resources required),
and make it so much easier to manage the code. It is really not advisable to
skip this step (read: your contribution may not be accepted, which really is in
no-ones interest, least your own) unless it is a tiny, non-controversial change
like a typo.

git checkout -b 65_my_bugfix

This is the command to start a new (topic) branch. You'll want to start with the
github issue number and add a short description for the task.

## work on the issue / branch

As described above, you can now edit the code and tests to work on the issue.
You may use the github issue for discussion or help. You can also push the branch
to github and collaborate on the code. Or have someone review it.

Use guard, write minitests, edit (according to code guidelines) until happy.
Commit, push and create a pull request.

## about committing

Regular small commits make for the best workflow. Where the line goes is a little
bit experience, but often it is no more than 5 affected files, no more than 50-60
lines affected. For a professional, 1-4 hours, for a beginner more.

Commits should be grouped around topics. Ideally (but not always) a commit takes the
whole project back to green (all tests working). But this is not always possible
and should not keep you from making commits. Commit when you have made some kind
of milestone, some small but cohesive change.

Usually beginners tend to make to large commits, but just to mention that there is also
a lower limit. Technical a single line may be a commit, but it would have to be a very,
possibly very very important line. Ie a critical fix, a version update know to break
things.

Usually i don't commit changes under 10 lines. If they happen, i band them together
with the next commit, possibly mention them in the (then multi-line) commit message.

About commit messages, they should describe the change in passive mode, as if the
commit made the changes. Ie "Fixes bug 36" , or "Adds method XXX to YY"

## pull request

A pull request is you asking the project owner (or anyone with commit rights) to
accept your work and merge it into the main (master) branch.

For small issues and especially when it has been discussed, this is a press of a button
for the project owner. But for larger changes, he/she may want to pull the
branch to their machine, look at it and consider.

If there are changes to be made, more discussion may follow. This may result in
you having to make more changes and so the process continues. This is why topic
branches are so important, to keep this kind of back and forth out of the main
branch and maintain a working / clean master branch.  

After a pull request has been accepted, you go back to the master branch, pull
changes, and start again with a new topic. And so life for the developer continues :-)
