#Copyright (C)1991-2006 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.






################################################################
# DE2 PIO
#
# This module implements a simple parallel input/output port 
# that can be accessed from the CPU's memory bus.
#
# -- REGISTER MAP (all registers are Data_Width wide):
#
#  Name       	   |  Addr.  |  Function
#  ----------------|---------|-------------------------------------------------
#  Data-in    	   | 0 (rd)  | Data value currently on pio inputs (read-only).
#  Data-out   	   | 0 (wr)  | New value to drive on pio outputs (write-only).
#  ----------------|---------|-------------------------------------------------
#   Data Direction | 1 (r/w) | (optional): Individual tristate control for
#                  |         | each port bit.  1=out, 0=in.
#  ----------------|---------|-------------------------------------------------
#   Interrupt Mask | 2 (r/w) | (optional): Per-bit irq enable/disable
#  ----------------|---------|-------------------------------------------------
#   Edge Capture   | 3 (r/w) | (optional): Per-bit edge-capture register.
#  ----------------|---------|-------------------------------------------------
#
# By default, the PIO block will have only one internal address
# (Data-in / Data-out).  The other three registers only "pop into existence"
# if the "has_tri" (--> Data Direction), "irq_type"
# (--> Interrupt Mask), or "edge_type" parameters are set.
#
# There are two distinct applications of this module:  One where the
# I/O bits of the parallel port are connected to on-chip devices, and
# the other where the parallel port is connected off-chip.
#
# ** On-chip pio connections
#
#  In this case, there is an associated input register and output register
#  for every bit in the PIO block.  If you write to the output register
#  you set a value on the pio outputs, and if you read from the input
#  register you get the current value from the pio inputs.  The input
#  and output wires are distinct.
#
#  By default, the pio block will have both input and output pins.
#  you can independently control the presence/absence of both
#  inputs and outputs with the two parameters $PIO_INPUT_PINS and
#  $PIO_OUTPUT_PINS, respectively.  These are true/false parameters
#
# ** Off-chip pio connections.
#
# If you so desire, the pio block can have combined inout 
# (bidirectional input/output) pins instead of separate input pins and
# separate output pins.  This means the outputs can *only* go to
# external device pins--it's the only place on an Apex chip where
# physical tri-state structures exist.  If this is what you want,
# then you set the $PIO_TRISTATE_PINS attribute.  In this case,
# the pio register set will also include a data-direction register
# for software control of the output drivers.
#
# If you set the $PIO_TRISTATE_PINS parameter true, then
# this module's in_port and out_port connections will "go away" and
# be replaced by a single n-bit connection named bidir_port. It
# is the caller's (instantiator's) responsibility to connect
# all the individual bits of bidir_port to an I/O port on the top-level
# of the APEX device's design.
#
# --Variable Width
#
# This module can be between 1 and 32 bits wide, giving you
# between 1 and 32 I/Os you can control (that'd be 1..32 inputs and
# 1..32 outputs, if $PIO_TRISTATE_PINS is false).
#
# --Edge Capture
#
# By default, the pio block just lets you read input bit levels.  You 
# may, however, optionally choose an edge-capture function by
# setting the PIO_EDGE_CAPTURE parameter to one of the three
# values "RISING", "FALLING", or "ANY."  If the PIO_EDGE_CAPTURE
# parameter has one of these values, then the pio block will
# include an additional, CPU-readable edge-capture register as
# internal register #3.
#
# Each bit in the edge-capture register is set when the
# requested edge type ("RISING", "FALLING," or "ANY"), is seen 
# on the corresponding input-bit.  Once any bit in the edge-capture
# register is set, it can only be cleared by a -write- operation to the
# edge-capture register.  A write-operation to the edge-capture register
# clears all bits.
#
# The default value for PIO_EDGE_CAPTURE is "NONE," corresponding to
# no edge capture feature and no edge-capture register.
#
#
# --Interrupt Control
#
# By default, the pio block does not generate an interrupt, and has
# no interrupt-control logic or registers.  If you set the 
# $PIO_INTERRUPT parameter to "LEVEL" or "EDGE", then the block will include
# both an irq-pin to the CPU and an internal interrupt-masking register.
# 
# If PIO_INTERRUPT is set to "LEVEL," then the irq output will be driven
# active (1) whenever any given input-bit is true (1), and the 
# corresponding bit in the interrupt-masking register is also true (1).
#
# If PIO_INTERRUPT is set to "EDGE," then the irq output will be driven
# active (1) whenever any given bit in the edge-capture register is true (1)
# and the corresponding bit in the interrupt-masking register is also 
# true (1).  PIO_INTERRUPT may -not- be set to edge unless the 
# PIO_EDGE_CAPTURE parameter is also set to one of the three values
# "RISING," "FALLING," or "ANY."
#
#
# --No output-data read-back.
#
# Many pio-devices like this allow software to read-back the value
# currently sitting in the data-output registers.  This feature, while
# sometimes handy, is not strictly necessary--The software can know,
# after all, what value was written into the pio output register by
# other means (e.g. remembering the value).  An output-register readback 
# feature would prevent unused register bits from being "eaten" (see above), 
# and would increase the hardware complexity of the readback mux. 
# In the name of keeping this device as simple and LE-efficient as possible,
# the output-register read-back feature has been eliminated.
#
# Assumptions:
#
# * The internal registers are presumed to run off the same clock (clk) 
#   as the CPU.
#
# * This is a "normal" peripheral with one-wait-state read access.
#
# * This peripheral is not bytewise-writeable.  A case can be made for
#   a byte-writeable pio, but simplicity is the order of the day.
#
################################################################

use europa_all;
use strict;

#START:
my $project = e_project->new(@ARGV);

# Make a copy so we don't write-back derived parameter values, etc.
my $Options = &copy_of_hash($project->WSA());
my $SBI     = &copy_of_hash($project->SBI("s1"));

# Add the data-width in with our options (this is something we care about).
# Along with the "Has_IRQ" setting, which we also care about.
#
$Options->{width}   = $SBI->{Data_Width};
$Options->{has_irq} = $SBI->{Has_IRQ};

&make_pio ($project->top(), $Options);

$project->output();

# Just one more thing...
# poke the driven testbench value into the ptf file if required
if ($Options->{Do_Test_Bench_Wiring} &&
    ($Options->{has_tri} || $Options->{has_in})
    )
{
   my $port = ($Options->{has_in})? "in_port": 
       ($Options->{has_tri})? "bidir_port":
       &ribbit ("bad port selection");

   $project->module_ptf()->{PORT_WIRING}
   {"PORT $port"}{test_bench_value} = eval 
       ($Options->{Driven_Sim_Value});

   $project->ptf_to_file();
}

################################################################
# Validate_PIO_Options
#
# Checks all my PTF-parameters to be sure they're good.
#
################################################################
sub Validate_PIO_Options
{
  my ($Options) = (@_);

  # Boolean variables specify what kind of I/O we have:
  #
  &validate_parameter ({hash    => $Options,
                        name    => "has_tri",
                        type    => "boolean",
                        default => 0,
                       });

  &validate_parameter ({hash    => $Options,
                        name    => "has_in",
                        type    => "boolean",
                        default => 0,
                       });

  &validate_parameter ({hash    => $Options,
                        name    => "has_out",
                        type    => "boolean",
                        default => 1,
                       });

  # Check for illegal combinations.  If we have a tri-state port,
  # then we can't have input/output:
  &validate_parameter ({hash         => $Options,
                        name         => "has_tri",
                        excludes_all => ["has_in", "has_out"],
                       });

  &validate_parameter ({hash    => $Options,
                        name    => "irq_type",
                        allowed => ["NONE", "LEVEL", "EDGE"],
                       });

  &validate_parameter ({hash    => $Options,
                        name    => "edge_type",
                        allowed => ["NONE", "RISING", "FALLING", "ANY"],
                       });

  &validate_parameter ({hash    => $Options,
                        name    => "width",
                        range   => [1, 32],
                       });

  &validate_parameter ({hash    => $Options,
                        name    => "reset_value",
                        type    => "integer",
                        default => 0,
                       });

  # Test to make sure the reset-value fits:
  $Options->{reset_value_bits} = &Bits_To_Encode($Options->{reset_value});
  &validate_parameter ({hash    => $Options,
                        name    => "reset_value_bits",
                        range   => [0, $Options->{width}],
                       });

  # Build-up some derived "Option" values, which are handy to 
  # have as booleans:
  $Options->{has_any_input}  = $Options->{has_tri} || $Options->{has_in};
  $Options->{has_any_output} = $Options->{has_tri} || $Options->{has_out};

  # If we've specified an IRQ, there must be some kind of input.
  # Likewise for edge-detection.
  $Options->{has_edge}       = $Options->{edge_type} ne "NONE";
  $Options->{irq_on_edge}    = $Options->{irq_type}  eq "EDGE";

  &validate_parameter ({hash         => $Options,
                        name         => "has_irq",
                        optional     => 1,
                        requires     => "has_any_input",
                       });

  &validate_parameter ({hash         => $Options,
                        name         => "has_edge",
                        optional     => 1,
                        requires     => "has_any_input",
                       });

  &validate_parameter ({hash         => $Options,
                        name         => "irq_on_edge",
                        optional     => 1,
                        requires     => "has_edge",
                       });

#    warn "done with options\n";
#    foreach my $key (keys (%$Options))
#    {
#       warn "  $key gets $Options->{$key}\n";
#    }

}

################################################################
# make_pio
#
# Given a name and a hashful of options, builds an e_module object
# which implements a PIO peripheral.
#
################################################################
sub make_pio
{
  my ($module, $Opt) = (@_);
  &Validate_PIO_Options ($Opt);

  # Create a new, empty module, and mark it as the one into which
  # all new "things" should go.  It gets unmarked when this subroutine
  # exits and "$marker" is destroyed.
  #
  my $marker = e_default_module_marker->new($module);

  # Leo is silly about hating the range [0:0] applied to scalars.
  # To get around this, we precompute the bit-ragen appropriate for 
  # this PIO -as a string-, which may be null ("") for a 1-bit PIO.
  #
  my $bitrange = ($Opt->{width} > 1)? '[' . ($Opt->{width} - 1) . ':0]' : "";

  e_signal->adds (
                  [edge_capture_wr_strobe => 1],
                  [clk_en => 1,0,1],
                  [chipselect => 1],
                  [clk => 1],
                  [reset_n => 1],
                  );

  # We don't really use the global clock-enable in this peripheral:
  e_assign->add (["clk_en", 1]);

  ################
  # First, declare my PIO port signals:
  #
  e_port->add(["bidir_port", $Opt->{width}, "inout"]) if $Opt->{has_tri};
  e_port->add(["in_port",    $Opt->{width}, "in"   ]) if $Opt->{has_in};
  e_port->add(["out_port",   $Opt->{width}, "out"  ]) if $Opt->{has_out};

  ################
  # Addressable-register infrastructure:
  #    Read-mux             (starts off blank--sometimes doesn't exist)
  #    readdata-register    (also sometimes doesn't exist)
  #    avalon-slave port    (always exists)
  #    read/writedata ports (sometimes don't exist)
  #
  e_avalon_slave->add ({name => "s1",});  # I want my slave-ports seen by the SOPC-Builder.
  e_port->add(["address", 2, "in"]);

  if ($Opt->{has_any_output} || $Opt->{has_irq} || $Opt->{has_edge}) {
    e_port->adds(["writedata", $Opt->{width}, "in"],
                 ["write_n"  ,            1 , "in"]);
  }

  my $read_mux;
  if ($Opt->{has_any_input}) 
  {
    e_port->add(["readdata",  $Opt->{width}, "output"]);
    $read_mux = e_mux->add ({lhs  => e_signal->add (["read_mux_out",
                                                     $Opt->{width}  ]),
                             type => "and-or",
                             });
    # Note that the register on "readdata" implies one-wait-state access.
    e_register->add ({out => "readdata",
                      in  => "read_mux_out"});
  }

  ################
  # Writeable data-out register, if reqired.
  #
  if ($Opt->{has_any_output}) {
    e_register->add 
      ({out         => e_signal->add (["data_out", $Opt->{width}]),
        in          => "writedata $bitrange",
        enable      => "chipselect && ~write_n && (address == 0)",
        async_value => $Opt->{reset_value},
       });

    # While we're here, do the actual output-assignment:
    if ($Opt->{has_tri}) {
      # Lovingly-assign each bit depending on direction-register.
      # Deal with Leo's hatred of bit-selects on scalar wires:
      if ($Opt->{width} == 1) {
        e_assign->add (["bidir_port", "data_dir ? data_out : 1'bZ"]);
      } else {
        for (my $i = 0; $i < $Opt->{width}; $i++) {
          e_assign->add (["bidir_port[$i]", 
                          "data_dir[$i] ? data_out[$i] : 1'bZ"]);
        }
      }
    }

    e_assign->add (["out_port", "data_out"]) if $Opt->{has_out};
  }

  ################ 
  # Readable data-in register, if required.
  # 
  if ($Opt->{has_any_input}) {
    e_signal->add(["data_in", $Opt->{width}]);

    e_assign->add(["data_in", "in_port"   ]) if $Opt->{has_in};
    e_assign->add(["data_in", "bidir_port"]) if $Opt->{has_tri};

    $read_mux->add_table ("(address == 0)" => "data_in");
  }

  ################
  # Writeable / Readable data-direction register, if required.
  #
  if ($Opt->{has_tri}) {
    e_register->add ({out    => e_signal->add (["data_dir", $Opt->{width}]),
                      in     => "writedata $bitrange",
                      enable => "chipselect && ~write_n && (address == 1)",
                     });

    $read_mux->add_table ("(address == 1)" => "data_dir");
  }

  ################
  # Writeable/readable interrupt-masking register, if required.
  #

  if ($Opt->{has_irq}) {
    e_register->add ({out    => e_signal->add (["irq_mask", $Opt->{width}]),
                      in     => "writedata $bitrange",
                      enable => "chipselect && ~write_n && (address == 2)",
                     });

    $read_mux->add_table ("(address == 2)" => "irq_mask");

    e_port->add(["irq" => 1, "output"]);
    ##########
    # While we're in here, compute the IRQ-result:
    if      ($Opt->{irq_type} eq "LEVEL") {
      e_assign->add (["irq", "|(data_in      & irq_mask)"]) 
    } elsif ($Opt->{irq_type} eq "EDGE") {
      e_assign->add (["irq", "|(edge_capture & irq_mask)"]) 
    } else {
      &ribbit ("Unexpected bad irq_type: $Opt->{irq_type}");
    }
  }

  ################
  # Readable / clearable edge-capture register.
  # Each bit of this register is set by an edge on the corresponding 
  # input-bit, and all 
  #
  if ($Opt->{has_edge}) {
    e_signal->add (["edge_capture", $Opt->{width}]);
    $read_mux->add_table ("(address == 3)" => "edge_capture");

    e_assign->add ([
                    "edge_capture_wr_strobe",
                    "chipselect && ~write_n && (address == 3)",
                    ]);

    # Create S/R registers for each bit, MSB-first (so list is in right order)
    # Deal with Leo's hatred of bit-selects on scalar wires:
    if ($Opt->{width} == 1) {
        e_register->add ({out        => "edge_capture",
                          sync_set   => "edge_detect",
                          sync_reset => "edge_capture_wr_strobe",
                         });
    } else {
      for (my $i = 0; $i < $Opt->{width}; $i++) {
        e_register->add ({out        => "edge_capture[$i]",
                          sync_set   => "edge_detect[$i]",
                          sync_reset => "edge_capture_wr_strobe",
                         });
      }
    }

    ################
    # Edge-detection mechanism
    #
    # Synchronize incoming data-signals (this bit us in both the 
    #   1.0 and 1.1 releases).  
    e_register->add({in => "data_in", delay => 2});

    e_signal->add (["edge_detect", $Opt->{width}]);
    if ($Opt->{edge_type}      eq "RISING") {
      e_assign->add (["edge_detect", " d1_data_in & ~d2_data_in"]);
    } elsif ($Opt->{edge_type} eq "FALLING") {
      e_assign->add (["edge_detect", "~d1_data_in & d2_data_in"]);
    } elsif ($Opt->{edge_type} eq "ANY") {
      e_assign->add (["edge_detect", " d1_data_in ^  d2_data_in"]);
    } else {
      &ribbit ("Unexpected bad edge type: $Opt->{edge_type}");
    }
  }
  return $module;
}





