FROM ros:rolling

RUN mkdir -p ros2_ws/src

COPY demo_nodes_cpp ros2_ws/src/demo_nodes_cpp

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt-get update && rosdep install -y \
      --from-paths \
        ros2_ws/src \
      --ignore-src \
    && rm -rf /var/lib/apt/lists/*
    
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    cd ros2_ws && \
    colcon build
    
RUN sed --in-place --expression \
      '$isource "/ros2_ws/install/setup.bash"' \
      /ros_entrypoint.sh
      
# launch ros package
CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener.launch.py"]
