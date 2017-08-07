function my_plot(net,iter)
X=net.data;
lasts=zeros(length(net.nodes),1);
% axes(handles.axes4);
plot(X(:,1) , X(:,2),'Og','MarkerFaceColor','g','MarkerSize',1);
hold on;
title(strcat('iteration',num2str(iter)));
for pp=1:length(net.nodes)
    nnn=net.nodes(pp);
    lasts(pp)=nnn.last_it;
end
thresh=mean(lasts);
counter=0;
for pp=1:length(net.nodes)
    nnn=net.nodes(pp);
    if(nnn.last_it>=thresh)
        counter=counter+1;
        weights(counter,:)=nnn.weights;
        if(weights(counter,1)==0)
            fprintf(pp)
        end
    end
end
% DT=delaunayTriangulation(weights);
% if(size(DT,1)>4) 
%     triplot(DT,'-ob','MarkerFaceColor','r','MarkerEdgeColor','k','MarkerSize',3);
% else
plot(weights(:,1),weights(:,2),'or','MarkerFaceColor','b','MarkerEdgeColor','k')
% end
hold off;
legend('data','weights');
pause(0.2);


hold off;


                   
