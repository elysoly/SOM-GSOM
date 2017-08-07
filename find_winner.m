function index=find_winner(weights,data)

dist=zeros(length(weights),1);
for i=1:length(weights)
   dist(i)= norm(weights(i,:)-data); 
end
[~,index]=min(sum(dist,2));
