# BRYSoundEffectPlayer

Convenience wrapper around some of Apple's Audio Service functions used for playing sound effects.

## Installation

Via [CocoaPods](http://cocoapods.org), of course:

    pod install BRYSoundEffectsPlayer

## Usage

An instance of `BRYSoundEffectPlayer` will cache sounds in memory until a low memory warning occurs, or if `playsSoundsConcurrently` is set to `NO` and a sound that is already being played must be disposed of in order to stop it.
 
If your needs are more advanced, you probably want to use `AVAudioPlayer` instead.

## License

Available for use under the MIT license: [http://bryan.mit-license.org](http://bryan.mit-license.org)