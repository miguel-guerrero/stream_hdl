# stream_hdl
An experimental HDL where everything is a stream of data.


## Introduction

This tool provides an alternative to entering pipelined designs. A design consists of a set of streams. Streams are defined between operators.  Each stream carries a set of flags.

* from upstream/master to downstream/slave

  * flags AFLV

     * A = Abort
     * F = First
     * L = Last
     * V = Valid

* from downstream/slave to upstream/master 

  * AB

    * A = Abort
    * B = Busy

Each operator must obey the flow control slave flags  feed from a downstremam operator
and inform an upstream operator when it cannot accept data through its set of 
control upstream operators.

*First* and *Last* allow the stream to delimit specific segments of data.

## Type of streams

   * input: input stream with provided mflags but no sflags (cannot be flow controlled back)
   * output: 

     * `sin`: input stream with master/slave flags
     * `sout`: output stream with master/slave flags
     * `hstr`: harcoded stream with flags harcoded as AFLV=b0111 and AB=b00


## Dependencies

    $ git submodule update --init --recursive
