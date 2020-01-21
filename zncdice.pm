# zncdice.pm v1.0 by Sven Roelse
# Copycat idea: https://github.com/gryphonshafer/Bot-IRC-X-Dice

# Example: 
# !roll 2d6+2

# 21-01-2020 - v1.0 first draft

use 5.014;
use strict;
use warnings;
use diagnostics;
use utf8;

use Games::Dice;
use POE::Component::IRC::Common;

package zncdice;
use base 'ZNC::Module';

sub description {
    "ZNC Dice rolling bot."
}

sub module_types {
    $ZNC::CModInfo::NetworkModule
}

sub put_chan {
    my ($self, $chan, $msg) = @_;
    $self->PutIRC("PRIVMSG $chan :$msg");
}

sub OnChanMsg {
    my ($self, $nick, $chan, $message) = @_;

    $nick = $nick->GetNick;
    $chan = $chan->GetName;
    # Strip colors and formatting
    if (POE::Component::IRC::Common::has_color($message)) {
        $message = POE::Component::IRC::Common::strip_color($message);
    }
    if (POE::Component::IRC::Common::has_formatting($message)) {
        $message = POE::Component::IRC::Common::strip_formatting($message);
    }
    if (my ($param) = $message=~/^!roll\s+(\d*d[\d%]+(?:[+\-*\/]\d+)?)/) {
            $self->put_chan($chan, Games::Dice::roll($param));
    }

    return $ZNC::CONTINUE;
}
1;
