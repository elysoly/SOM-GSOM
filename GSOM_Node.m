classdef GSOM_Node < handle
   properties      
      right
      left
      up
      down
      error
      it
      x
      y
      last_it
      last_changed
      data
      weights
   end
   methods
        function obj=GSOM_Node(dim, xx, yy)
        %Initialize this node.
        %Create a weight vector of the given dimension:
        %Initialize the weight vector with random values between 0 and 1.
        obj.weights=rand(1,dim);

        %Remember the error occuring at this particular node
		obj.error = 0.0;

		% Holds the number of the iteration during the node has been inserted.
		obj.it = 0;

		%Holds the number of the last iteration where the node has won.
		obj.last_it = 0;

		%Holds the best-matching data.
		obj.data = -1;
		obj.last_changed = 0;

		%This node has no neighbours yet.
		obj.right = nan;
		obj.left  = nan;
		obj.up    = nan;
		obj.down  = nan;

		%Copy the given coordinates.
		obj.x = xx; 
        obj.y = yy;
      end
      
      function self=adjust_weights(obj,target,learn_rate)
        %""" Adjust the weights of this node. """

       obj.weights=obj.weights+learn_rate*(target-obj.weights);
       self=obj;
      end
    
      function ret=is_boundary(obj)
        %""" Check if this node is at the boundary of the map. """
        ret=0;
        if(isa(obj.right,'GSOM_Node')==0 || isa(obj.left,'GSOM_Node')==0 || isa(obj.up,'GSOM_Node')==0 || isa(obj.down,'GSOM_Node')==0)
            ret=1;
        end	
      end
      
   end
end