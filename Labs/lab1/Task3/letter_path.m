letter_path_g = [
0 235 285;
0 230 270;
0 240 250;
0 260 235;
0 290 245;
0 295 265;
0 290 290;
0 265 290;
0 265 265;]

letter_path_g=[letter_path_g(:,1) letter_path_g(:,3) letter_path_g(:,2)]

letter_path_g = letter_path_g- letter_path_g(1,:)
scaler = 0.005;

letter_path_g= letter_path_g*scaler