function Qs = Qsynth(Qh, Ns, p, n)
% Inputs:
% Qh: Cell array of historical streamflow matrices, one per site
% Ns: Number of synthetic years to generate
% p (optional): Flow percentile (and below) to make more frequent
% n (optional): Times more likely
%
% Returns:
% Qs: Cell array of synthetic streamflow matrices
%
% Other important variables:
% Nh: Number of years in historical record
% M: Matrix of random indices to draw from the historical record
% C: Matrix of uncorrelated standard normal variables

    if iscell(Qh)
        num_sites = length(Qh);
    else
        error(['Q_historical must be a cell array ' ...
               'containing one or more 2-D matrices.']);
    end
    
    Nh = length(Qh{1}(:,1));
    for i=2:num_sites
        if length(Qh{i}(:,1)) ~= Nh
            error('All matrices in Q_historical must be the same size.');
        end
    end
        
    Ns = Ns+1; % for Kirsch et al. inter-year correlation method
    if nargin == 2
        nQ = Nh;
    elseif nargin == 4
        n = n-1; % so that n=2 creates one duplicate entry
        nQ = Nh + floor((p*Nh+1)*n);
    else
        error('Incorrect number of arguments.');
    end
    M = randi(nQ, Ns, 52);
    
    for k=1:num_sites
        Q = Qh{k};
        if nargin == 4
            % find lowest p% of values for each week
            % and append a sample of them to the historical Q
            temp = sort(Q);
            low_flows = temp(1:ceil(p*Nh),:); 
            ix = randi(ceil(p*Nh), floor((p*Nh+1)*n), 1);
            Q = vertcat(Q, low_flows(ix,:));
        end
        Yh = log(Q);

        mu = zeros(1,52);
        sigma = zeros(1,52);
        Z = zeros(nQ, 52);

        for i=1:52
            mu(i) = mean(Yh(:,i));
            sigma(i) = std(Yh(:,i));
            Z(:,i) = (Yh(:,i) - mu(i)) / sigma(i);
        end
        Zh_vector = reshape(Z',1,[]);
        Zh_prime = reshape(Zh_vector(27:(nQ*52-26)),52,[])';

        % The correlation matrices should use the historical Z's
        % (the "appended years" do not preserve correlation)
        U = chol(corr(Z(1:Nh,:)));
        U_prime = chol(corr(Zh_prime(1:Nh-1,:)));

        for i=1:52
            C(:,i) = Z(M(:,i), i);
        end
        
        C_vector = reshape(C(:,:)',1,[]);
        C_prime(:,:) = reshape(C_vector(27:(Ns*52-26)),52,[])';
        Zs_original(:,:) = C(:,:)*U;
        Zs_prime(:,:) = C_prime(:,:)*U_prime;

        Zs(:,1:26) = Zs_prime(:,27:52);
        Zs(:,27:52) = Zs_original(2:Ns, 27:52);

        for i=1:52
            Qsk(:,i) = exp(Zs(:,i)*sigma(i) + mu(i));
        end
        
        Qs{k} = Qsk;
    end
    
end
