classdef GSOM <handle
   properties
      nodes;
      it
      max_it	
      num_it
      init_lr
      alpha
      gamma
	  output 
      GT
      data
      dim
      Max_iteration
      neurons_numbers
      learning_rates
      handles
   end
   methods
       function dist=distance(v1,v2)
        %Calculate the euclidean distance between two  arrays
		dist = norm(v1-v2); 
       end
       function winner=find_bmu(obj, vec)
	   %Find the best matching unit within the map for the given input vector.
		dist=inf;
		winner = -1;
        for i=1:length(obj.nodes)
            node=obj.nodes(i);
			d = norm(vec- node.weights);
            if(d < dist)
				dist = d;
				winner = node;
            end
        end
		
       end
       function selected=find_similar_boundary(self, node)
		%Find the most similar boundary node to the given node.
		dist = inf;
		selected = nan;
        for i=1: length(self.nodes)
            boundary=self.nodes(i);
            if(boundary.is_boundary() && boundary ~= node)
              % bondary is what we want now!
                d =norm(node.weights- boundary.weights);
                if (d < dist)
                    dist = d;
                    selected = node;
                end
            end
        end
           
       end
       function new_node=insert(obj, x, y, init_node)
		% Create new node
		new_node = GSOM_Node(obj.dim, x, y);
		obj.nodes(length(obj.nodes)+1)=new_node;
% 		 Save the number of the current iteration. We need this to prune
% 		 this node later (if neccessary).
		new_node.it =obj.it;
        new_node.last_it= obj.it;
		% Create the connections to possible neighbouring nodes.
        for i=1:length(obj.nodes)
            node=obj.nodes(i);
			% Left, Right, Up, Down
            if node.x == x - 1 && node.y == y
				new_node.left = node;
				node.right = new_node;
            end
            if node.x == x + 1 && node.y == y
				new_node.right = node;
				node.left = new_node;
            end
            if node.x == x && node.y == y + 1
				new_node.up = node;
				node.down = new_node;
            end
            if node.x == x && node.y == y - 1
				new_node.down = node;
				node.up = new_node;
            end
        end
		% Calculate new weights, look for a neighbour.
		neigh = new_node.left;
        if(isa(neigh,'GSOM_Node')==0)
            neigh = new_node.right;
        end
        if(isa(neigh,'GSOM_Node')==0)
            neigh = new_node.up;
        end
        if(isa(neigh,'GSOM_Node')==0)
           neigh = new_node.down;
        end
        if(isa(neigh,'GSOM_Node')==0)
            fprintf('insert: No neighbour found!');
        end
        
        for i=1 :length(new_node.weights)
			new_node.weights(i) = 2 * init_node.weights(i) - neigh.weights(i);
        end
       end
       function nodes=grow(self, node)
		% Grow this GSOM. """
		% We grow this GSOM at every possible direction.
		nodes = node;
        if(isa(node.left,'GSOM_Node') == 0)
			nn = self.insert(node.x - 1, node.y, node);
			nodes(length(nodes)+1)=(nn);
			fprintf(strcat('Growing left at: (' ,num2str(node.x),',',num2str(node.y),') -> (', num2str(nn.x),', ' , num2str(nn.y),')\n'))
        end
        if (isa(node.right,'GSOM_Node') == 0)
			nn = self.insert(node.x + 1, node.y, node);
			nodes(length(nodes)+1)=[nn];
			fprintf(strcat('Growing right at: (' ,num2str(node.x),',',num2str(node.y),') -> (', num2str(nn.x),', ' , num2str(nn.y),')\n'))
        end
        if (isa(node.up,'GSOM_Node') == 0)
			nn = self.insert(node.x, node.y + 1, node);
			nodes(length(nodes)+1)=(nn);
			fprintf(strcat('Growing up at: (' ,num2str(node.x),',',num2str(node.y),') -> (', num2str(nn.x),', ' , num2str(nn.y),')\n'))
        end
        if (isa(node.down,'GSOM_Node') == 0)
			nn = self.insert(node.x, node.y - 1, node);
			nodes(length(nodes)+1)=(nn);
			fprintf(strcat('Growing down at: (' ,num2str(node.x),',',num2str(node.y),') -> (', num2str(nn.x),', ' , num2str(nn.y),')\n'))
        end
        nodes=nodes(2:length(nodes));
        
       end
       function nodes=node_add_error(obj, node, error)
		%Add the given error to the error value of the given node.
		%This will also take care of growing the map (if necessary) and
		%distributing the error along the neighbours (if necessary) 
		node.error =node.error+ error;
        nodes=nan;
		%Consider growing
        if(node.error > obj.GT)
            if( ~node.is_boundary()==1)
				% Find the boundary node which is most similar to this node.
				node = obj.find_similar_boundary(node);
                if (isa(node,'GSOM_Node')==0)
					fprintf('GSOM: Error: No free boundary node found!');
				% Distribute the error along the neighbours.
				% Since this is not a boundary node, this node must have
				% 4 neighbours.
                    node.error = 0.5 * self.GT;
                    node.left.error  =  node.left.error  + self.gamma * node.left.error;
                    node.right.error =  node.right.error + self.gamma * node.right.error;
                    node.up.error    =  node.up.error    + self.gamma * node.up.error;
                    node.down.error  =  node.down.error  + self.gamma * node.down.error;
                end
            end
			nodes = obj.grow(node);
        end
       end        
       function obj=GSOM(dataset, spread_factor,max_it_threshold,my_alpha,my_gamma,handles)
           %soread_factor=0.5 default
	   %Initializes this GSOM using the given data.
	   %Assign the data
		obj.data = dataset;
	  %Determine the dimension of the data.
		obj.dim = size(obj.data,2);
		% Calculate the growing threshold:
		obj.GT = -obj.dim * log(spread_factor);
        obj.Max_iteration=max_it_threshold;
        obj.neurons_numbers=zeros(max_it_threshold,1);
        obj.learning_rates=zeros(max_it_threshold,1);

        % Create the 4 starting Nodes.
		n00 = GSOM_Node(obj.dim, 0, 0);
		n01 = GSOM_Node(obj.dim, 0, 1);
		n10 = GSOM_Node(obj.dim, 1, 0);
		n11 = GSOM_Node(obj.dim, 1, 1);
      

		% Create starting topology
		n00.right = n10;
		n00.up    = n01;
		n01.right = n11;
		n01.down  = n00;
		n10.up    = n11;
		n10.left  = n00;
		n11.left  = n01;
		n11.down  = n10;

        obj.nodes=(n00);
		obj.nodes(1:4)=([n00,n01,n10,n11]);
        
		% Set properties
		obj.it = 0;		       % Current iteration
		obj.max_it = length(obj.data);
		obj.num_it = 1000;     % Total iterations
		obj.init_lr = 1;     % Initial value of the learning rate
		obj.alpha = my_alpha;
        obj.gamma=my_gamma;
		obj.output = 'gsom.csv';
        obj.handles=handles;
       end
       function remove_unused_nodes(self)
		% Remove all nodes from the GSOM that have not been used. 
		to_remove = GSOM_Node(self.dim,1,1);
		%Iterate over all nodes.
        for i=1:length(self.nodes)
            node=self.nodes(i);
			% Different rules for nodes that have been used or not.
			iterations_not_won = self.it - node.last_it;

			% If we have 50 nodes, every node is allowed not to win 50 times
			% in a row. This means every node must be picked at least once.
            if iterations_not_won < length(self.nodes) * 4.0 * (1 + self.it/length(self.data)) 
                continue
            end


			% First, remove the connections to the neighbouring nodes.
            if isa(node.left,'GSOM_Node')==1
                node.left.right = nan;
            end
            if isa(node.up,'GSOM_Node')==1
                node.up.down=nan;
            end
            if isa(node.down,'GSOM_Node')==1
                node.down.up    = nan;
            end
            if isa(node.right,'GSOM_Node')==1
                node.right.left = nan;
            end

			%Save this node for removing.
			to_remove(length(to_remove)+1)=(node);
        end
		% Now remove all marked nodes.
        %remove first one cause we mannally added this
        for i=2:length(to_remove)
            node=to_remove(i);
			fprintf(strcat('\nRemoving node @ ' , num2str(node.x) , ', ' , num2str(node.y),' - Current it: ' , num2str(self.it) , ' - Last time won: ' ,num2str(node.last_it)));
         l=length(self.nodes);
           for k=1:l
              tmp=self.nodes(k);
              if(tmp.x==node.x && tmp.y==node.y)
                 break; 
              end
           end
           self.nodes=[self.nodes(1:k-1),self.nodes(k+1:l)];
           
        end
        
       end    
       function  train(obj)
		% Select the next input.
        epoch=1;
        while(epoch<=obj.Max_iteration)
            obj.neurons_numbers(epoch)=length(obj.nodes);
            epoch=epoch+1;
            axes(obj.handles.axes1);
            my_plot(obj,epoch)
%             obj.it=0;
            for it=1:length(obj.data)
                input=obj.data(it,:);
                learn_rate = obj.init_lr * obj.alpha * (1 - 3.8/length(obj.nodes));
                obj.learning_rates(epoch)=learn_rate;
                BMU = obj.find_bmu(input);
                BMU.last_it = obj.it;
                %Adapt the weights of the direct topological neighbours
                neighbours = [BMU];
                if(isa(BMU.left,'GSOM_Node')==1)
                    neighbours(length(neighbours)+1)=BMU.left;
                end
                if(isa(BMU.right,'GSOM_Node')==1)
                    neighbours(length(neighbours)+1)=BMU.right;
                end
                if(isa(BMU.up,'GSOM_Node')==1)
                    neighbours(length(neighbours)+1)=BMU.up;
                end
                if(isa(BMU.down,'GSOM_Node')==1)
                    neighbours(length(neighbours)+1)=BMU.down;
                end

                for i=1:length(neighbours)
                    node=neighbours(i);
                    node.adjust_weights(input, learn_rate)
                end

                err =norm(BMU.weights- input);
                nodes = obj.node_add_error(BMU,err);
                
        %         if growing==1
        %             recalc_nodes(length(recalc_nodes)+1:length(recalc_nodes)+length(nodes))=nodes;
        %         end
                obj.it =obj.it + 1;

        %         used_data = [];
        %         for i=1:length(self.nodes)
        %             node=self.nodes(i);
        % 			used_data(i)=node.data;
        %         end  


            end
        end

       end       
   end
end