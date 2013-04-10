# LAME

[![Gem Version](https://badge.fury.io/rb/lame.png)](http://badge.fury.io/rb/lame)
[![Build Status](https://travis-ci.org/rdvdijk/lame.png?branch=master)](https://travis-ci.org/rdvdijk/lame)
[![Code Climate](https://codeclimate.com/github/rdvdijk/lame.png)](https://codeclimate.com/github/rdvdijk/lame)
[![Coverage Status](https://coveralls.io/repos/rdvdijk/lame/badge.png?branch=master)](https://coveralls.io/r/rdvdijk/lame)
[![Dependency Status](https://gemnasium.com/rdvdijk/lame.png)](https://gemnasium.com/rdvdijk/lame)

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

Then configure some settings:

```ruby
encoder.configure do |config|
  config.quality = 4
  config.bitrate = 192
end
```

See all configuration options in the Configuration section below.

Then encode some audio data. Both `left` and `right` are arrays of `short`
values (ranging from −32,768 to +32,767). The `mp3_data` variable is a
binary string of MP3 encoded audio. This can be appended to a file or
streamed to a server.

```ruby
encoder.encode_short(left, right) do |mp3_data|
  # do something with encoded mp3 data..
end
```

See all encoding methods in the Encoding section below.

### Configuration

Here are all the encoding configuration options. The values use here are the
defaults. You can set any option prior to encoding.

```ruby
encoder.configure do |config|
  config.bitrate                     = 128
  config.quality                     = 3
  config.mode                        = :join_stereo

  config.number_of_samples           = 4294967295
  config.number_of_channels          = 2
  config.input_samplerate            = 44100
  config.output_samplerate           = 44100
  config.scale                       = 0.95
  config.scale_left                  = 1.0
  config.scale_left                  = 1.0
  config.analysis                    = false
  config.decode_only                 = false
  config.force_mid_side              = false
  config.free_format                 = false
  config.replay_gain                 = false
  config.decode_on_the_fly           = false
  config.preset                      = :EXTREME # no LAME default
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
  config.asm_optimization.mmx       = true
  config.asm_optimization.amd_3dnow = true
  config.asm_optimization.sse       = true

  # these options can't be "unset" once set to true
  config.id3.v2              = false
  config.id3.v1_only         = false
  config.id3.v2_only         = false
  config.id3.v1_space        = false
  config.id3.v2_padding      = false
  config.id3.v2_padding_size = 128

  config.id3.write_automatic = true
  config.id3.title           = nil
  config.id3.artist          = nil
  config.id3.album           = nil
  config.id3.year            = nil
  config.id3.comment         = nil
  config.id3.track           = nil
  config.id3.genre           = nil

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
  config.vbr.mean_bitrate        = 128
  config.vbr.min_bitrate         = 0
  config.vbr.max_bitrate         = 0
  config.vbr.enforce_min_bitrate = false

  config.filtering.low_pass_frequency  = 17000
  config.filtering.low_pass_width      = -1
  config.filtering.high_pass_frequency = 0
  config.filtering.high_pass_width     = -1

  config.psycho_acoustics.ath_only          = false
  config.psycho_acoustics.ath_short         = false
  config.psycho_acoustics.ath               = true
  config.psycho_acoustics.ath_type          = 4
  config.psycho_acoustics.ath_lower         = 3.0
  config.psycho_acoustics.athaa_type        = -1
  config.psycho_acoustics.athaa_sensitivity = 0.0
end
```

### Encoding

See [`encoding_spec.rb`](spec/integration/encoding_spec.rb) for examples how
to encode a WAV file to an MP3 file.

The available encoding functions are:

```ruby
encoder = LAME::Encoder.new

# encode shorts (−32,768 to +32,767), for 16-bit audio
encoder.encode_short(left, right) do |mp3_frame|
  # ...
end

# encode floats (−1.0 to +1.0), for 32-bit floating point audio
encoder.encode_float(left, right) do |mp3_frame|
  # ...
end

# encode longs (system dependent, +/- 2^(bits_per_long-1)
encoder.encode_long(left, right) do |mp3_frame|
  # ...
end

# encode interleaved shorts
encoder.encode_interleaved_short(samples) do |mp3_frame|
  # ...
end

# encode interleaved floats
encoder.encode_interleaved_float(samples) do |mp3_frame|
  # ...
end
```

The `left` and `right` are arrays of sample values for the given data type.

### Decoding

See [`decoding_spec.rb`](spec/integration/decoding_spec.rb) for examples how
to decode an MP3 file to an WAV file.

### Development

This section contains some references used during development of this gem.

#### ID3v2 tags

To use ID3v2 tags in files, see this post on the `lame-dev` mailing list:

http://sourceforge.net/mailarchive/message.php?msg_id=18557283

So:

1. Disable automatic id3tag writing
2. Write id3v2 tag at start of file (keep track of size of this tag)
3. Write audio to file
4. Write id3v1 tag at end of file
5. Write vbr 'lametag' at start of audio (using the size of the id3v2 tag)

See the example code in [`encoding_spec.rb`](spec/integration/encoding_spec.rb).

#### Decoding

Check this link for a 'simple' example. Note that we need to deal with the
ID3 tags ourselves before decoding MP3 frames.

http://sourceforge.net/mailarchive/message.php?msg_id=26907120

Analysis of `lame_decode_initfile` in `get_audio.c`:

1. `hip_decode_init`
2. Read ID3 tags, starting with "ID3"
3. The length of the ID3 tag are at the start (right after "ID3")
4. Optionally read the contents of the ID3 tag, or just skip it
5. Check if there is a "AID" header, and skip it
6. Read up until the first "mp123 syncword"

After this, we are ready to decode MP3 data.

1. Check if there are some samples in the internal decoder by passing an empty
   input-buffer into the decoder.
2. If some decoded audio samples were indeed left in the internal decoder, do 
   something useful with them.
3. Repeat this until no audio is left in the internal buffer.
4. Read some data from the file (starting at the "mp123 syncword") and feed it
   to the decoder.
5. Handle the decoded audio.
6. Now repeat this process (`GOTO 1`) until the end of the MP3 file.

See the example code in [`decoding_spec.rb`](spec/integration/decoding_spec.rb).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
