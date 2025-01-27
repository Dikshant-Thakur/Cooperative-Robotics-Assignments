function [pandaArm] = ComputeTaskReferences(pandaArm,mission)
% Compute distance between tools for plotting
pandaArm.dist_tools = norm(pandaArm.ArmL.wTt(1:3, 4) - pandaArm.ArmR.wTt(1:3, 4));
% Compute minimum altitude reference ALWAYS

% pandaArm.ArmL.xdot.alt = ...;
% pandaArm.ArmR.xdot.alt = ...;

% Compute joint limits task reference ALWAYS
% Create a velocity away from the limits => move to the middle between jlmax and jlmin
% 
% pandaArm.ArmL.xdot.jl = ...;
% pandaArm.ArmR.xdot.jl = ...;

jlmin = [-2.8973;-1.7628;-2.8973;-3.0718;-2.8973;-0.0175;-2.8973];
jlmax = [2.8973;1.7628;2.8973;-0.0698;2.8973;3.7525;2.8973];

switch mission.phase
    case 1
        % LEFT ARM
        % -----------------------------------------------------------------
        % Tool position and orientation task reference
        [ang_l, lin_l] = CartError(pandaArm.ArmL.wTg,pandaArm.ArmL.wTt);

        pandaArm.ArmL.xdot.tool = 0.2*[ang_l;lin_l];
        % limit the requested velocities...
        pandaArm.ArmL.xdot.tool(1:3) = Saturate(pandaArm.ArmL.xdot.tool(1:3),0.2);
        pandaArm.ArmL.xdot.tool(4:6) = Saturate(pandaArm.ArmL.xdot.tool(4:6),0.2);

        % End effector minimum altitude for left
        pandaArm.ArmL.min_dis = [pandaArm.ArmL.bTe(3,4)];
        pandaArm.ArmL.xdot.min = -0.2 * (0.15 - norm(pandaArm.ArmL.min_dis));
        pandaArm.ArmL.xdot.min = [0 0 0 0 0 pandaArm.ArmL.xdot.min]';

        % joint limits
        % max
        pandaArm.ArmL.joints_dis_max = abs(jlmax) - abs(pandaArm.ArmL.q);
        pandaArm.ArmL.joints_dis_max = max(pandaArm.ArmL.joints_dis_max, 0)';
        pandaArm.ArmL.dot.joints_max = zeros(6, 14);

        pandaArm.ArmR.joints_dis_max = abs(jlmax) - abs(pandaArm.ArmR.q);
        pandaArm.ArmR.joints_dis_max = max(pandaArm.ArmR.joints_dis_max, 0)';
        pandaArm.ArmR.dot.joints_max = zeros(6, 14);

        % min
        pandaArm.ArmL.joints_dis_min = abs(jlmax) - abs(pandaArm.ArmL.q);
        pandaArm.ArmL.joints_dis_min = min(pandaArm.ArmL.joints_dis_max, 0)';
        pandaArm.ArmL.dot.joints_min = zeros(6, 14);

        pandaArm.ArmR.joints_dis_min = abs(jlmax) - abs(pandaArm.ArmR.q);
        pandaArm.ArmR.joints_dis_min = min(pandaArm.ArmR.joints_dis_max, 0)';
        pandaArm.ArmR.dot.joints_min = zeros(6, 14);


        % pandaArm.ArmR.dot.joints_max = [0 0 pandaArm.ArmL.min_dis 0 0 0 ];
        % RIGHT ARM
        % -----------------------------------------------------------------
        % Tool position and orientation task reference
        [ang_r, lin_r] = CartError(pandaArm.ArmR.wTg,pandaArm.ArmR.wTt);
       
        pandaArm.ArmR.xdot.tool = 0.2*[ang_r;lin_r];
        % limit the requested velocities...
        pandaArm.ArmR.xdot.tool(1:3) = Saturate(pandaArm.ArmR.xdot.tool(1:3),0.2);
        pandaArm.ArmR.xdot.tool(4:6) = Saturate(pandaArm.ArmR.xdot.tool(4:6),0.2);

        % End effector minimum altitude for right
        pandaArm.ArmR.min_dis = [pandaArm.ArmR.bTe(3,4)];
        pandaArm.ArmR.xdot.min = -0.2 * (0.15- norm(pandaArm.ArmR.min_dis));
        pandaArm.ArmR.xdot.min= [0 0 0 0 0 pandaArm.ArmR.xdot.min]';

    % case 2
    %     % Perform the rigid grasp of the object and move it
    % 
    %     % COMMON
    %     % -----------------------------------------------------------------
    %     % Rigid Grasp Constraint
    %     pandaArm.xdot.rc = ...;
    % 
    %     % LEFT ARM
    %     % -----------------------------------------------------------------        
    %     % Object position and orientation task reference
    %     [ang, lin] = CartError();
    %     pandaArm.ArmL.xdot.tool = ...;
    %     % limit the requested velocities...
    %     pandaArm.ArmL.xdot.tool(1:3) = Saturate();
    %     pandaArm.ArmL.xdot.tool(4:6) = Saturate();
    % 
    %     % RIGHT ARM
    %     % -----------------------------------------------------------------
    %     % Object position and orientation task reference
    %     [ang, lin] = CartError();
    %     pandaArm.ArmR.xdot.tool = ...;
    %     % limit the requested velocities...
    %     pandaArm.ArmR.xdot.tool(1:3) = Saturate();
    %     pandaArm.ArmR.xdot.tool(4:6) = Saturate();
    % case 3
    %     % Stop any motions
    %     % LEFT ARM
    %     % -----------------------------------------------------------------
    %     % Tool position and orientation task reference
    %     pandaArm.ArmL.xdot.tool(1:3) = ...;
    %     pandaArm.ArmL.xdot.tool(4:6) = ...;
    % 
    %     % RIGHT ARM
    %     % -----------------------------------------------------------------
    %     % Tool position and orientation task reference
    %     pandaArm.ArmR.xdot.tool(1:3) = ...;
    %     pandaArm.ArmR.xdot.tool(4:6) = ...;
end


