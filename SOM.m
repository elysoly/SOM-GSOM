function result= SOM(tr_data,arch_neuron,threshold,learning_mode,neighborhood,handles)
% clear;
% close all;
% clc;
% tr_data=load('dataset.csv');
% tr_data=datasample(tr_data,size(tr_data,1),'Replace',false);
% threshold=100;
% learning_mode='rec';
% neighborhood='exp';
% arch_neuron=[5,6];
batch_size=str2double(handles.batch_size.String);
neuron_number=arch_neuron(1)*arch_neuron(2);
% neuron_number=30;
sigma0=round(max(arch_neuron)/2)+2;
winning_count=zeros(arch_neuron);
updating_count=ones(arch_neuron);
sum_of_dead_neurons=zeros(threshold,1);
result=0;
epoch=1;
beta0=0.7;
X=tr_data(:,1:size(tr_data,2)-1);


for i=1:size(X,2)
    X(:,i)=(X(:,i)- min(X(:,i))) / (max(X(:,i))-min(X(:,i)));
end
% Y=tr_data(:,size(tr_data,2));
weights=rand(neuron_number,size(X,2));
% weights=ones(neuron_number,size(X,2)) .* repmat([0.5,0.5],neuron_number,1);
% .* repmat(max(X),neuron_number,1);
initial_weights=weights;
weights_new=weights;
%%1D for now!
NM=zeros(neuron_number,1);
r=round((neuron_number-1)/2);
for i=1:r
    NM(i)= r-i+1;
end
for i=r+1:neuron_number
    NM(i)= i-r-1;
end
if(strcmp(learning_mode,'batch'))
    weights_new=zeros(size(weights));
    while(epoch<threshold)
        dead_neurons=zeros(arch_neuron);
        beta=beta0*exp(-epoch/threshold);%learning rate
        sigma=round(sigma0*exp(-epoch/threshold));%neighborhood_size
        batch=0;
            for i=1:length(X)
                batch=batch+1;
                if(batch>batch_size || i>=length(X))
                    batch=0;
                    for w_i=1:length(weights)
                        if(updating_count(w_i)>1)
                            updating_count(w_i)=updating_count(w_i)-1;
                        end
                        weights(w_i,:)=weights(w_i,:)+ (weights_new(w_i,:)./[updating_count(w_i),updating_count(w_i)]);
                    end
                    weights_new=zeros(size(weights));
                    updating_count=ones(arch_neuron);
                    %%plot training result
                    axes(handles.axes1);
%                     plot(X(:,1) , X(:,2),'Og','MarkerFaceColor','g');

                    plot(X(:,1) , X(:,2),'Og','MarkerFaceColor','g','MarkerSize',1.5);
                    title(strcat('iteration',num2str(epoch)));
                    hold on ; 
            %         plot(weights(:,1),weights(:,2),'or','MarkerFaceColor','b','MarkerEdgeColor','k')
                    DT=delaunayTriangulation(weights);
                    if(size(DT,1)>0) 
                        triplot(DT,'-ob','MarkerFaceColor','r','MarkerEdgeColor','k','MarkerSize',3);
                    else
                       plot(weights(:,1),weights(:,2),'or','MarkerFaceColor','b','MarkerEdgeColor','k')
                    end
                    hold off;
                    legend('data','weights');
                    pause(0.2);
                    
                end
                winner_index=find_winner(weights,X(i,:));
                winning_count(winner_index)=winning_count(winner_index)+1;
                dead_neurons(winner_index)=1;
                if(arch_neuron(2)>1)
                    [winner_row,winner_clm]=ind2sub(arch_neuron,winner_index);
                    index=1;
                    for p=max(1,winner_row-sigma):1:min(winner_row+sigma,arch_neuron(1))
                        for q=max(1,winner_clm-sigma):1:min(winner_clm+sigma,arch_neuron(2))
                            neighbs_index(index,1)=p;
                            neighbs_index(index,2)=q;
                            updating_count(p,q)=updating_count(p,q)+1;
                            index=index+1;
                        end
                    end
                else
                    neighbs_index=max(1,winner_index-sigma):1:min(winner_index+sigma,neuron_number);           
                    neighbs_index=neighbs_index.';
                    updating_count(neighbs_index)=updating_count(neighbs_index)+1;

                end
                for j=1:length(neighbs_index)
                    tmp=neighbs_index(j,:);
                    if(arch_neuron(2)>1)
                        tmp1=sub2ind(arch_neuron,tmp(1),tmp(2));
                    else 
                        tmp1=tmp;
                    end
                    d=max(abs(winner_index-tmp1));
    %                 tmp2=exp(-0.1*d);
                    tmp2=neighborhood_strength(d,neighborhood,0.7);
                    tmp3=X(i,:)-weights(tmp1,:);
%                     weight_update=weights(tmp1,:)+beta*tmp3*tmp2;
                    weight_update=beta*tmp3*tmp2;
                    weights_new(tmp1,:)= weights_new(tmp1,:) + weight_update;
                end
            end
        sum_of_dead_neurons(epoch)=sum(sum(dead_neurons==0));
        epoch=epoch+1;

        %%plot training result
    end 
                   
else %recursive mode
    while(epoch<threshold)
        dead_neurons=zeros(arch_neuron);
        beta=beta0*exp(-epoch/threshold);%learning rate
        sigma=round(sigma0*exp(-epoch/threshold));%neighborhood_size
            for i=1:length(X)
                winner_index=find_winner(weights,X(i,:));
                winning_count(winner_index)=winning_count(winner_index)+1;
                dead_neurons(winner_index)=1;
                if(arch_neuron(2)>1)
                    [winner_row,winner_clm]=ind2sub(arch_neuron,winner_index);
                    index=1;
                    for p=max(1,winner_row-sigma):1:min(winner_row+sigma,arch_neuron(1))
                        for q=max(1,winner_clm-sigma):1:min(winner_clm+sigma,arch_neuron(2))
                            neighbs_index(index,1)=p;
                            neighbs_index(index,2)=q;
                            index=index+1;
                        end
                    end
                else
                    neighbs_index=max(1,winner_index-sigma):1:min(winner_index+sigma,neuron_number);           
                    neighbs_index=neighbs_index.';
                end
                for j=1:length(neighbs_index)
                    tmp=neighbs_index(j,:);
                    if(arch_neuron(2)>1)
                        tmp1=sub2ind(arch_neuron,tmp(1),tmp(2));
                    else 
                        tmp1=tmp;
                    end
                    d=max(abs(winner_index-tmp1));
    %                 tmp2=exp(-0.1*d);
                    tmp2=neighborhood_strength(d,neighborhood,0.7);
                    tmp3=X(i,:)-weights(tmp1,:);
                    weights_new(tmp1,:)=weights(tmp1,:)+beta*tmp3*tmp2;
                end
                weights=weights_new;          
            end
        sum_of_dead_neurons(epoch)=sum(sum(dead_neurons==0));
        epoch=epoch+1;

        %%plot training result
        axes(handles.axes1);
        plot(X(:,1) , X(:,2),'Og','MarkerFaceColor','g','MarkerSize',1.5);
        hold on ; 
        DT=delaunayTriangulation(weights);
        if(size(DT,1)>0) 
            triplot(DT,'-ob','MarkerFaceColor','r','MarkerEdgeColor','k','MarkerSize',3);
        else
           plot(weights(:,1),weights(:,2),'or','MarkerFaceColor','b','MarkerEdgeColor','k')
        end
%             plot(weights(:,1),weights(:,2),'or');
%             plot(weights(:,1),weights(:,2),'y','linewidth',1);
%             plot(weights(:,1)',weights(:,2)','y','linewidth',1);
%            
        hold off;
        legend('data','weights');
        title(strcat('iteration',num2str(epoch)));
        pause(0.2);
    end 
end

axes(handles.axes2);
plot(sum_of_dead_neurons,'-m','LineWidth',2,'MarkerEdgeColor','k','MarkerSize',10)
xlabel('iteration');
ylabel('number of ead neurons');
axes(handles.axes3);
bar(reshape(winning_count,[numel(winning_count),1]));
xlabel('# neuron');
ylabel('Winning times');

% res=kmeans(weights,5);
% res=clusterdata(weights,5);
z=linkage(weights,'ward');
res = cluster(z,'maxclust',5);
cluster_centers=zeros(5,2);
for j=1:5
    cluster_centers(j,:)= mean(weights(res==j,:));
end
% dendrogram(z);
axes(handles.axes4);
plot(X(:,1) , X(:,2),'Og','MarkerFaceColor','g','MarkerSize',1.5);


hold on 
for i=1:length(res)
    hold on
    switch res(i)
        case 1
            plot(weights(i,1),weights(i,2),'Or');
        case 2
            plot(weights(i,1),weights(i,2),'Ob');
        case 3
            plot(weights(i,1),weights(i,2),'Om');
        case 4
            plot(weights(i,1),weights(i,2),'Oc');
        case 5
            plot(weights(i,1),weights(i,2),'Ok');
     end
end
legend('data','neurons');
axes(handles.axes5);
l=arch_neuron(1);
b=arch_neuron(2);
C=reshape(weights(:,1),arch_neuron);
xhex=[0 1 2 2 1 0]; % x-coordinates of the vertices
yhex=[2 3 2 1 0 1]; % y-coordinates of the vertices
for i=1:b
    j=i-1;
    for k=1:l
        m=k-1;
        patch((xhex+mod(k,2))+2*j,yhex+2*m,C(k,i)) % make a hexagon at [2i,2j]
        hold on
    end
end
axis equal
title('Weights input1');


axes(handles.axes6);
C=reshape(weights(:,2),arch_neuron);
for i=1:b
    j=i-1;
    for k=1:l
        m=k-1;
        patch((xhex+mod(k,2))+2*j,yhex+2*m,C(k,i)) % make a hexagon at [2i,2j]
        hold on
    end
end
axis equal
title('Weights input2');
%%%labeling
labels=zeros(length(tr_data),1);
for j=1:length(tr_data)
    dist=zeros(5,1);
    for p=1:5
        dist(p)=norm(cluster_centers(p,:)-X(j,:));
    end
    [~,labels(j)]=min(dist);
end
my_nmi=NMI(labels,tr_data(:,3));
rand_index=RandIndex(labels,tr_data(:,3));
handles.nmi_label.String=num2str(my_nmi);
handles.rand_index_label.String=num2str(rand_index);

