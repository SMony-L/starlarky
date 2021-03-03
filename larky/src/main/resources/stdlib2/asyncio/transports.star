def BaseTransport:
    """
    Base class for transports.
    """
    def __init__(self, extra=None):
        """
        Get optional transport information.
        """
    def is_closing(self):
        """
        Return True if the transport is closing or closed.
        """
    def close(self):
        """
        Close the transport.

                Buffered data will be flushed asynchronously.  No more data
                will be received.  After all buffered data is flushed, the
                protocol's connection_lost() method will (eventually) called
                with None as its argument.
        
        """
    def set_protocol(self, protocol):
        """
        Set a new protocol.
        """
    def get_protocol(self):
        """
        Return the current protocol.
        """
def ReadTransport(BaseTransport):
    """
    Interface for read-only transports.
    """
    def is_reading(self):
        """
        Return True if the transport is receiving.
        """
    def pause_reading(self):
        """
        Pause the receiving end.

                No data will be passed to the protocol's data_received()
                method until resume_reading() is called.
        
        """
    def resume_reading(self):
        """
        Resume the receiving end.

                Data received will once again be passed to the protocol's
                data_received() method.
        
        """
def WriteTransport(BaseTransport):
    """
    Interface for write-only transports.
    """
    def set_write_buffer_limits(self, high=None, low=None):
        """
        Set the high- and low-water limits for write flow control.

                These two values control when to call the protocol's
                pause_writing() and resume_writing() methods.  If specified,
                the low-water limit must be less than or equal to the
                high-water limit.  Neither value can be negative.

                The defaults are implementation-specific.  If only the
                high-water limit is given, the low-water limit defaults to an
                implementation-specific value less than or equal to the
                high-water limit.  Setting high to zero forces low to zero as
                well, and causes pause_writing() to be called whenever the
                buffer becomes non-empty.  Setting low to zero causes
                resume_writing() to be called only once the buffer is empty.
                Use of zero for either limit is generally sub-optimal as it
                reduces opportunities for doing I/O and computation
                concurrently.
        
        """
    def get_write_buffer_size(self):
        """
        Return the current size of the write buffer.
        """
    def write(self, data):
        """
        Write some data bytes to the transport.

                This does not block; it buffers the data and arranges for it
                to be sent out asynchronously.
        
        """
    def writelines(self, list_of_data):
        """
        Write a list (or any iterable) of data bytes to the transport.

                The default implementation concatenates the arguments and
                calls write() on the result.
        
        """
    def write_eof(self):
        """
        Close the write end after flushing buffered data.

                (This is like typing ^D into a UNIX program reading from stdin.)

                Data may still be received.
        
        """
    def can_write_eof(self):
        """
        Return True if this transport supports write_eof(), False if not.
        """
    def abort(self):
        """
        Close the transport immediately.

                Buffered data will be lost.  No more data will be received.
                The protocol's connection_lost() method will (eventually) be
                called with None as its argument.
        
        """
def Transport(ReadTransport, WriteTransport):
    """
    Interface representing a bidirectional transport.

        There may be several implementations, but typically, the user does
        not implement new transports; rather, the platform provides some
        useful transports that are implemented using the platform's best
        practices.

        The user never instantiates a transport directly; they call a
        utility function, passing it a protocol factory and other
        information necessary to create the transport and protocol.  (E.g.
        EventLoop.create_connection() or EventLoop.create_server().)

        The utility function will asynchronously create a transport and a
        protocol and hook them up by calling the protocol's
        connection_made() method, passing it the transport.

        The implementation here raises NotImplemented for every method
        except writelines(), which calls write() in a loop.
    
    """
def DatagramTransport(BaseTransport):
    """
    Interface for datagram (UDP) transports.
    """
    def sendto(self, data, addr=None):
        """
        Send data to the transport.

                This does not block; it buffers the data and arranges for it
                to be sent out asynchronously.
                addr is target socket address.
                If addr is None use target address pointed on transport creation.
        
        """
    def abort(self):
        """
        Close the transport immediately.

                Buffered data will be lost.  No more data will be received.
                The protocol's connection_lost() method will (eventually) be
                called with None as its argument.
        
        """
def SubprocessTransport(BaseTransport):
    """
    Get subprocess id.
    """
    def get_returncode(self):
        """
        Get subprocess returncode.

                See also
                http://docs.python.org/3/library/subprocess#subprocess.Popen.returncode
        
        """
    def get_pipe_transport(self, fd):
        """
        Get transport for pipe with number fd.
        """
    def send_signal(self, signal):
        """
        Send signal to subprocess.

                See also:
                docs.python.org/3/library/subprocess#subprocess.Popen.send_signal
        
        """
    def terminate(self):
        """
        Stop the subprocess.

                Alias for close() method.

                On Posix OSs the method sends SIGTERM to the subprocess.
                On Windows the Win32 API function TerminateProcess()
                 is called to stop the subprocess.

                See also:
                http://docs.python.org/3/library/subprocess#subprocess.Popen.terminate
        
        """
    def kill(self):
        """
        Kill the subprocess.

                On Posix OSs the function sends SIGKILL to the subprocess.
                On Windows kill() is an alias for terminate().

                See also:
                http://docs.python.org/3/library/subprocess#subprocess.Popen.kill
        
        """
def _FlowControlMixin(Transport):
    """
    All the logic for (write) flow control in a mix-in base class.

        The subclass must implement get_write_buffer_size().  It must call
        _maybe_pause_protocol() whenever the write buffer size increases,
        and _maybe_resume_protocol() whenever it decreases.  It may also
        override set_write_buffer_limits() (e.g. to specify different
        defaults).

        The subclass constructor must call super().__init__(extra).  This
        will call set_write_buffer_limits().

        The user may call set_write_buffer_limits() and
        get_write_buffer_size(), and their protocol's pause_writing() and
        resume_writing() may be called.
    
    """
    def __init__(self, extra=None, loop=None):
        """
        'message'
        """
    def _maybe_resume_protocol(self):
        """
        'message'
        """
    def get_write_buffer_limits(self):
        """
        f'high ({high!r}) must be >= low ({low!r}) must be >= 0'
        """
    def set_write_buffer_limits(self, high=None, low=None):
