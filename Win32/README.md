This module was generated using `Examples/generate_basics.jai` from [Jai-Win32-Generator](https://github.com/ostef/Jai-Win32-Generator)

## How to use
This module is divided into different submodules, but importing these individually is inconvenient because you would not be able to namespace them with the same name.

For ease of use there is a base sentinel module that you import with the name "Win32", and you select what parts of the Win32 API you want using module parameters. See module.jai and other example files in [the repository](https://github.com/ostef/Jai-Win32-Generator) for more information.

The sentinel module #imports the other modules instead of #loading them to prevent different instantiations of Win32 to create duplicate symbols.
