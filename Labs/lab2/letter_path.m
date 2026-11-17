letter_path_j = [
    118 238;
    145 238;
    145 277;
    134 283;
    122 282;
    118 273;];

scaler = 0.006;

letter_path_j=[letter_path_j(:,1) -letter_path_j(:,2)];
letter_path_j = letter_path_j- letter_path_j(1,:);


% Calculate the Euclidean norm along rows (dimension 2)
norms = vecnorm(letter_path_j, 2, 2)

% Find the row index of the largest norm
[len, idx] = max(norms)

% Extract the longest vector
longestVec = letter_path_j(idx, :)

letter_path_j= letter_path_j/(len/10)

% Calculate the Euclidean norm along rows (dimension 2)
norms = vecnorm(letter_path_j, 2, 2)

% Find the row index of the largest norm
[len, idx] = max(norms)

% Extract the longest vector
longestVec = letter_path_j(idx, :)