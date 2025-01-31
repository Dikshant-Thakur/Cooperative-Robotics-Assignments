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


% End effector minimum altitude for left
pandaArm.ArmL.min_dis = [pandaArm.ArmL.wTt(3,4)];
pandaArm.ArmL.xdot.min = -1 * (0.15 - norm(pandaArm.ArmL.min_dis));
pandaArm.ArmL.xdot.min = [0 0 0 0 0 pandaArm.ArmL.xdot.min]';

% End effector minimum altitude for right
pandaArm.ArmR.min_dis = [pandaArm.ArmR.wTt(3,4)];
pandaArm.ArmR.xdot.min = -1* (0.15- norm(pandaArm.ArmR.min_dis));
pandaArm.ArmR.xdot.min= [0 0 0 0 0 pandaArm.ArmR.xdot.min]';

% joint limits
pandaArm.ArmR.xdot.joints = zeros(14,1);       
pandaArm.ArmL.xdot.joints = zeros(14,1);

switch mission.phase
    case 1
        % LEFT ARM
        % -----------------------------------------------------------------
        % Tool position and orientation task reference
        [ang_l, lin_l] = CartError(pandaArm.ArmL.wTg,pandaArm.ArmL.wTt);

        pandaArm.ArmL.xdot.tool = [ang_l;lin_l];
        % limit the requested velocities...
        pandaArm.ArmL.xdot.tool(1:3) = Saturate(pandaArm.ArmL.xdot.tool(1:3),1);
        pandaArm.ArmL.xdot.tool(4:6) = Saturate(pandaArm.ArmL.xdot.tool(4:6),1);

        % RIGHT ARM
        % -----------------------------------------------------------------
        % Tool position and orientation task reference
        [ang_r, lin_r] = CartError(pandaArm.ArmR.wTg,pandaArm.ArmR.wTt);
       
        pandaArm.ArmR.xdot.tool = [ang_r;lin_r];
        % limit the requested velocities...
        pandaArm.ArmR.xdot.tool(1:3) = Saturate(pandaArm.ArmR.xdot.tool(1:3),1);
        pandaArm.ArmR.xdot.tool(4:6) = Saturate(pandaArm.ArmR.xdot.tool(4:6),1);

    case 2
        % Perform the rigid grasp of the object and move it

        % COMMON
        % -----------------------------------------------------------------
        % Rigid Grasp Constraint
        % pandaArm.xdot.rc = ...;

        % LEFT ARM
        % -----------------------------------------------------------------        
        % Object position and orientation task reference
        % [ang_l, lin_l] = CartError(pandaArm.ArmL.wTg,pandaArm.ArmL.wTt);


        % con
        pandaArm.xdot.con = zeros(6,1);

        % move2
        [ang_l, lin_l] = CartError(pandaArm.wTog,pandaArm.ArmL.wTt);

        pandaArm.ArmL.xdot.tool = 0.2*[ang_l;lin_l];
        % limit the requested velocities...
        pandaArm.ArmL.xdot.tool(1:3) = Saturate(pandaArm.ArmL.xdot.tool(1:3),0.2);
        pandaArm.ArmL.xdot.tool(4:6) = Saturate(pandaArm.ArmL.xdot.tool(4:6),0.2);




        % grasp
        pandaArm.ArmL.xdot.grasp = [0 0 0 0 (0.2*(0.3 - pandaArm.ArmL.q(7))) 0]';

        % limit the requested velocities...
        pandaArm.ArmL.xdot.grasp(1:3) = Saturate(pandaArm.ArmL.xdot.grasp(1:3),0.2);
        pandaArm.ArmL.xdot.grasp(4:6) = Saturate(pandaArm.ArmL.xdot.grasp(4:6),0.2);

        % RIGHT ARM
        % -----------------------------------------------------------------
        % Object position and orientation task reference
        % [ang_r, lin_r] = CartError(pandaArm.ArmR.wTg,pandaArm.ArmR.wTt);
        pandaArm.ArmR.xdot.grasp = [0 0 0 0 (0.2*(0.03 - pandaArm.ArmR.q(7))) 0]';

        % limit the requested velocities...
        pandaArm.ArmR.xdot.grasp(1:3) = Saturate(pandaArm.ArmR.xdot.grasp(1:3),0.2);
        pandaArm.ArmR.xdot.grasp(4:6) = Saturate(pandaArm.ArmR.xdot.grasp(4:6),0.2);

        % move2
        [ang_l, lin_l] = CartError(pandaArm.wTog,pandaArm.ArmR.wTt);

        pandaArm.ArmR.xdot.tool = 0.2*[ang_l;lin_l];
        % limit the requested velocities...
        pandaArm.ArmR.xdot.tool(1:3) = Saturate(pandaArm.ArmR.xdot.tool(1:3),0.2);
        pandaArm.ArmR.xdot.tool(4:6) = Saturate(pandaArm.ArmR.xdot.tool(4:6),0.2);



    case 3
        % Stop any motions
        % LEFT ARM
        % -----------------------------------------------------------------
        % Tool position and orientation task reference
        pandaArm.ArmL.xdot.tool(1:3) = zeros(3,1);
        pandaArm.ArmL.xdot.tool(4:6) = zeros(3,1);

        % RIGHT ARM
        % -----------------------------------------------------------------
        % Tool position and orientation task reference
        pandaArm.ArmR.xdot.tool(1:3) = zeros(3,1);
        pandaArm.ArmR.xdot.tool(4:6) = zeros(3,1);
end


