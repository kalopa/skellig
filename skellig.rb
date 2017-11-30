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
require 'json'

require 'probe'
require 'mysql'
require 'ping'
require 'pop3'
require 'smtp'

module Skellig
  class Base
    #
    # Create a new Skellig configuration
    def initialize(configfile)
      @probes = []
      config = JSON.parse(File.open(configfile).read, :symbolize_names => true)
      config[:probes].each do |probe|
        klass = Skellig.const_get probe[:type] || "Ping"
        @probes << klass.new(probe)
      end
    end

    #
    # Execute all the probes (this doesn't return)
    def run_all_probes
      #
      # Start running the probes.
      while true do
        puts "\n***** Starting probe checks..."
        p @probes
        @run_time = Time.now
        runnable = @probes.sort_by {|probe| probe.next_run}
        puts "Runnables..."
        wait = runnable[0].next_run - @run_time 
        puts "WAIT TIME #{wait}"
        sleep(wait) if wait >= 1.0
        p runnable
        runnable.each do |probe|
          probe.check if probe.next_run <= @run_time
        end
      end
    end
  end
end
