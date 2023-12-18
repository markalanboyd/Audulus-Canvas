# Audulus-Canvas

## Intro

_Note: This is a work in progress and some documentation and features may be missing. Give the repo a star ⭐ and watch it 👁️ to keep up with development!_

The Canvas node in Audulus 4 uses [Lua](https://www.lua.org) to draw text and graphics. It works with an implementation of [vger](https://github.com/audulus/vger).

In the Canvas node, you are given several [built-in functions](/code/builtins/builtins.lua) to draw lines, rectangles, circles, and text.

This library extends these functions to help you easily and quickly craft custom visualizers and graphical user interfaces (GUIs) with just a few lines of code. The library is designed in such a way that you do not need to know (hardly) anything about programming in order to use it.

The goal of this library is to provide everything from a few small quality-of-life upgrades for simple tasks like drawing primitive shapes and creating buttons to an drop-in SVG parser and even a full-blown 3D engine.

## Contributing

If you're interested in what features are coming, check out the [roadmap](https://github.com/users/markalanboyd/projects/6).

If you have a feature request or found a bug, please [open an issue](https://github.com/markalanboyd/Audulus-Canvas/issues) for it. You can also ask questions, report bugs, or request features for this project on the [Audulus Discord](https://discord.gg/43CG7Trznj) in the [Lua channel](https://discord.gg/vcQqHQNP9t).

As this project is in the very early stages, I want to really solidify the library's conventions before accepting pull requests.

## Quickstart

The [quickstart guide](docs/quickstart.md) is written for people with little to no experience programming. If you just want to experiment a little or figure out how to add a custom button to your module, start here.

## Tutorials

If you want to learn how to use every aspect of the library, these [tutorials](docs/tutorials/tutorial_index.md) will explain all of its features step-by-step. Each tutorial is self-contained, so you don't need to read them in order. That said, if you're an absolute beginner, make sure you read the [Introduction to Functions](docs/tutorials/introduction-to-functions.md) guide.

## API Reference

The [API reference](docs/api.md) is the go-to guide if you want all of the details about each function.
