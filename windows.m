clear all

original = [1,2,3,4,1;
    4,5,6,7,3;
    7,8,9,10,5;
    1,2,3,4,4;
    1,2,3,4,4]

original_dim_1 = size(original,1)

original_dim_2 = size(original,2)

window = 3

columns = im2col(original, [window window])

wind_mean = col2im(mean(columns), [window window], [original_dim_1 original_dim_2], 'slider')
                                                                                                                                                                                                                                                                                                                              
new_dims = length(wind_mean) * 2 + 1

new = zeros(new_dims,new_dims)

for i = 1:size(wind_mean,1)
    for o = 1:size(wind_mean,2)
        new_index_i = i * 2
        new_index_o = o * 2
        new(new_index_i, new_index_o) = wind_mean(i,o)
    end
end

for 1:size(new,1)
    for 1:size(new,2)
        
