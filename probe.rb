#
# Copyright (c) 2017, Kalopa Research.  All rights reserved.  This is free
# software; you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation;
# either version 2, or (at your option) any later version.
#
# It is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this product; see the file COPYING.  If not, write to the Free
# Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#
# THIS SOFTWARE IS PROVIDED BY KALOPA RESEARCH "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL KALOPA RESEARCH BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
# USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
module Skellig
  class Probe
    attr_accessor :options, :status, :next_run, :fail_count

    DEFAULT_OPTS = {:frequency => 300, :retry => 5}

    STATE_NEW = 0
    STATE_GOOD = 1
    STATE_FAILING = 2
    STATE_FAILED = 3

    #
    # Create a generic probe
    def initialize(opts = {})
      opts = DEFAULT_OPTS.merge(opts)
      puts "Skellig#probe: opts=#{opts}"
      raise ArgumentError.new('probe name undefined') unless opts[:name]
      raise ArgumentError.new('IP address undefined') unless opts[:ip]
      @options = opts
      @status = STATE_NEW
      @next_run = Time.now
      @fail_count = 0
    end

    #
    # Execute a probe
    def execute(command)
      puts "Running command: #{command}..."
      %x(#{command})
      if $? == 0
        success
      else
        failure
      end
    end

    #
    # The probe check was a success
    def success
      puts "Probe Success."
      @next_run = Time.now + @options[:frequency]
      puts "Next run: #{@next_run}"
    end

    #
    # The probe check failed
    def failure
      puts "PROBE FAILURE!"
      @next_run = Time.now + @options[:frequency]
      puts "Next run: #{@next_run}"
    end
  end
end
