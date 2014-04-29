#--------------------------------------------------------------------------
# Copyright (c) Microsoft Open Technologies, Inc.
# All Rights Reserved. Licensed under the Apache 2.0 License.
#--------------------------------------------------------------------------
require 'log4r'
require 'vagrant'

module VagrantPlugins
  module WinAzure
    class Provider < Vagrant.plugin('2', :provider)
      attr_reader :driver

      def initialize(machine)
        @machine = machine

        # Load the driver
        machine_id_changed
      end

      def action(name)
        # Attempt to get the action method from the Action class if it
        # exists, otherwise return nil to show that we don't support the
        # given action.
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)
        nil
      end

      def machine_id_changed
        @driver = Driver.new(@machine)
      end

      def ssh_info
        # Run a custom action called "read_ssh_info" which does what it
        # says and puts the resulting SSH info into the `:machine_ssh_info`
        # key in the environment.
        env = @machine.action('read_ssh_info')
        env[:machine_ssh_info]
      end

      def rdp_info
        env = @machine.action('read_rdp_info')
        env[:machine_ssh_info]
      end

      def winrm_info
        env = @machine.action('read_winrm_info')
        env[:machine_ssh_info]
      end

      def state
        # Run a custom action we define called "read_state" which does what it
        # says. It puts the state in the `:machine_state_id` key in the env
        env = @machine.action('read_state')
        state_id = env[:machine_state_id]

        short = "Machine's current state is #{state_id}"
        long = ""

        # Return the MachineState object
        Vagrant::MachineState.new(state_id, short, long)
      end

      def to_s
        id = @machine.id.nil? ? 'new' : @machine.id
        "Azure (#{id})"
      end
    end
  end
end
