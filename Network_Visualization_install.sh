#!/bin/bash
#author Bryant Treacle
#date 20 Feb 18
#purpose: This script will install the Network Visualization Plusing in Kibana


#clear
echo "This script will install the Network Visualization Plugin in Kibana.  Would you like to continue? (Y/N)"
 read userselect

# Install Network_vis plugin
if [ ${userselect,,} = "y" ] ; then
    echo "Creating a New Directly for Kibana Plugins and mounting them to the Kibana docker container."
# Make a directory for kbn_network plugin
    mkdir -p /nsm/kibana/plugins
# Copy kbn_network folder to /nsm/kibana/plugins
    tar -xvf network_vis.tar -C /nsm/kibana/plugins
    chown -R root:root /nsm/kibana/plugins/*
    echo "Need to mount a new volume to the Kibana docker container.  This is done by utilizing the KIBANA_OPTIONS in the /etc/nsm/securityonion.conf file."
        currentkibanaoptions="$(sudo cat /etc/nsm/securityonion.conf | grep KIBANA_OPTIONS)"
    echo "Here are your current KIBANA_OPTIONS:   $currentlogkibanaoptions"
    echo "If you already have Kibana options configured  press 1, if not press any key to continue"
        read kibanachoice
	if [ $kibanachoice = "1" ] ; then
            echo "Add the following to your existing options to mount a new volume: --volume /nsm/kibana/plugins:/usr/share/kibana/plugins:ro"
            echo "Enter All logstash options as they should appear in the securityonion.conf file"
            read logstashoptions
                echo "Adding Kibana Options now"
            sudo sed -i 's|KIBANA_OPTIONS.*|'"$kibanaoptions"'|g' /etc/nsm/securityonion.conf
        else
            echo "Adding Kibana Options now"
            sudo sed -i 's|KIBANA_OPTIONS=""|KIBANA_OPTIONS="--volume /etc/logstash/Data:/:ro"|g' /etc/nsm/securityonion.conf
        # Allow logstash container access to /etc/logstash/Data directory
        fi
	echo "Rebuilding Kibana Docker Container"
	# Restart Kibana Docker
	so-kibana-restart
	echo "Complete"
elif  [ ${userselect,,} = "n" ] ; then
    echo "Exiting"
fi


