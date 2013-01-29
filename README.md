# LAME

FFI powered library for the [LAME MP3 encoder](http://lame.sourceforge.net/).

## Installation

Add this line to your application's Gemfile:

    gem 'lame'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lame

## Usage

Create a default `LAME::Encoder` with default settings:

```ruby
encoder = LAME::Encoder.new
```

Then configure some settings, if needed:

```ruby
encoder.configure do |config|
  config.quality = 4
  config.bitrate = 192
end
```

See all configuration options in the Configuration section below.

Then encode some audio data:

```ruby
encoder.encode_short(left, right) do |mp3_data|
  # do something with encoded mp3 data..
end
```

See all encoding methods in the Encoding section below.

### Configuration

(work in progress)

```ruby
# These are the defaults:
encoder.configure do |config|
  config.number_of_samples           = 4294967295
  config.input_samplerate            = 44100
  config.number_of_channels          = 2
  config.scale                       = 0.95
  config.scale_left                  = 1.0
  config.scale_left                  = 1.0
  config.output_samplerate           = 44100
  config.analysis                    = false
  config.decode_only                 = false
  config.quality                     = 3
  config.mode                        = :join_stereo
  config.force_mid_side              = false
  config.free_format                 = false
  config.replay_gain                 = false
  config.decode_on_the_fly           = false
  config.bitrate                     = 128
  config.preset                      = :V0 # no LAME default
  config.copyright                   = false
  config.original                    = true
  config.error_protection            = false
  config.extension                   = false
  config.strict_iso                  = true # no LAME default
  config.allow_different_block_types = false
  config.temporal_masking            = true
  config.inter_channel_ratio         = 0.0002
  config.disable_short_blocks        = false
  config.force_short_blocks          = false
  config.emphasis                    = false

  # auto-detected by default
  config.asm_optimizations.mmx     = true
  config.asm_optimizations.amd3now = true
  config.asm_optimizations.sse     = true

  config.id3.v2              = false
  config.id3.v1_only         = false
  config.id3.v2_only         = false
  config.id3.v1_space        = false
  config.id3.v2_padding      = false
  config.id3.v2_padding_size = 128

  config.quantization.reservoir      = true
  config.quantization.comp           = 9
  config.quantization.comp_short     = 9
  config.quantization.experimental_x = 9
  config.quantization.experimental_y = 0
  config.quantization.experimental_z = 0
  config.quantization.naoki          = true
  config.quantization.msfix          = 1.95

  config.vbr.write_tag           = true
  config.vbr.mode                = :vbr_off
  config.vbr.q                   = 4
  config.vbr.quality             = 4.0
  config.vbr.bitrate.mean        = 128
  config.vbr.bitrate.min         = 0
  config.vbr.bitrate.max         = 0
  config.vbr.bitrate.enforce_min = false

  config.filtering.low_pass.frequency  = 17000
  config.filtering.low_pass.width      = -1
  config.filtering.high_pass.frequency = 0
  config.filtering.high_pass.width     = -1

  config.psycho_acoustics.ath_only          = false
  config.psycho_acoustics.ath_short         = false
  config.psycho_acoustics.ath               = true # strange
  config.psycho_acoustics.ath_type          = 4
  config.psycho_acoustics.ath_lower         = 3.0
  config.psycho_acoustics.athaa_type        = -1
  config.psycho_acoustics.athaa_sensitivity = 0.0
end
```

### Encoding

TODO

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
