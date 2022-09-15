function Run_FFT()


    dir = './'
    fname = 'cat.jpg'

    file_name = [dir, fname];
    im = imread(file_name);
    [nr, nc, c_channels]= size(im);

    figure(1)
    clf
    imshow(im)
    title('Input Image')


    F_im = fft2(im, nr, nc);
    M = abs(F_im);
    Ph = angle(F_im);


    F_im = fftshift(F_im);
    M = abs(F_im);
    Ph = angle(F_im);

    M_show = LinearProjection(M);

    figure(2)
    clf
    imshow(uint8(M_show*255))
    title('Module')

    figure(3)
    clf
    imshow(Ph)
    title('Phase')

    nf = linspace(10, 90, 3)

    for i = 1:size(nf,2)
        

        R_im = Create_LFF (nr, nc, nf(i));

        MF = M.*R_im;
        M_show = LinearProjection(MF);
        figure(4+i)
        clf
        imshow(M_show)

        Z=MF.*exp(1i*Ph);
        Z=fftshift(Z);
        Z=fftshift(Z);
        Inv_F = ifft2(Z);

        Reconstructed = uint8(abs(Inv_F));

        figure(4+i+size(nf,2))
        clf
        imshow(Reconstructed)
        title("Reconstructed Image :"+ nf(i)+ "perc; PSNR = " + psnr(im, Reconstructed))

    end

return


function M_show = LinearProjection(M)


    [nr, nc, c_channels]= size(M);

    min_v = min(min(M));
    max_v = max(max(M));

    for i=1:nr
        for j=1:nc
            for k=1:c_channels
               
                    M_show(i,j,k) = (M(i,j,k)  - min_v(k))*255/(max_v(k) -min_v(k));
                
            end
        end
    end

    M_show = imadjust(M_show,[],[],0.5);


return 

function R_im = Create_LFF (nr, nc, perc_val)

    R_im = zeros(nr, nc);

    min_r = round(nr/2 - perc_val * nr /200);
    max_r= round(nr/2 + perc_val * nr /200);

    min_c = round(nc/2 - perc_val * nc /200);
    max_c= round(nc/2 + perc_val * nc /200);


    R_im(min_r:max_r, min_c:max_c)=1;

return 
