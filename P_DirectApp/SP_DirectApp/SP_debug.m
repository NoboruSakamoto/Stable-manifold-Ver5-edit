% ================================================
% x, p の計算結果の確認用スクリプト
% 1. ある初期値ξに対してk=0からk=maxまでのt-xpのグラフを描く
% 2. k=maxのときの全てのξに対するx-pのグラフを描く
% ================================================

colors = char('gcmyk');

if dbFlag == 1 &&...
   OKNG == 1

	tmp_xpT = transpose(Diagonalize * txp(:,2:dim*2+1)');
	time = txp(:,1);
	tmp_txpT = [time,tmp_xpT];

	if cFlag == 1
		plotcolor =char('r');
	else
		plotcolor =char('b');
	end
	if knum_i == knum
		% === 解曲面の表示 ===
		if dim == 1
			figure(30)
			plot(tmp_xpT(:,1),tmp_xpT(:,2),plotcolor)
			hold on
		elseif dim == 2
			figure(30)
			plot3(tmp_xpT(:,1),tmp_xpT(:,2),tmp_xpT(:,3),plotcolor)
			hold on
			figure(31)
			plot3(tmp_xpT(:,1),tmp_xpT(:,2),tmp_xpT(:,4),plotcolor)
			hold on
		elseif dim == 3
			figure(30)
			plot3(tmp_xpT(:,1),tmp_xpT(:,2),tmp_xpT(:,3),plotcolor)
			hold on
		elseif dim == 4
		elseif dim == 5
		end
	end

	if xi_i == ini_row

		if knum_i == knum
			plotcolor =char('r');
			plotwidth = 2;
		else
			tmpclr = rem(knum_i,5);
			if tmpclr == 0
				tmpclr = 5;
			end
			plotcolor = colors(tmpclr);
			plotwidth = 0.5;
		end

		% === Hamiltonianの表示 ===
		HAMK_n = f_hamcalcu(tmp_xpT(:,1:dim),tmp_xpT(:,dim+1:dim*2),Q,R);

		figure(201)
		plot(time,HAMK_n,plotcolor,'LineWidth',plotwidth)
		hold on
		title('time - Hamiltonian')
		xlabel('time')
		ylabel('Hamiltonian')

		% === 時間応答の表示 ===
		if dim == 1

			figure(101)

			subplot(211)
			plot(time, tmp_xpT(:,1),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x1')
			xlabel('time')
			ylabel('x1')

			subplot(212)
			plot(time, tmp_xpT(:,2),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p1')
			xlabel('time')
			ylabel('p1')

		elseif dim ==2

			figure(101)

			subplot(211)
			plot(time, tmp_xpT(:,1),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x1')
			xlabel('time')
			ylabel('x1')

			subplot(212)
			plot(time, tmp_xpT(:,2),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x2')
			xlabel('time')
			ylabel('x2')

			figure(102)

			subplot(211)
			plot(time, tmp_xpT(:,3),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p1')
			xlabel('time')
			ylabel('x2')

			subplot(212)
			plot(time, tmp_xpT(:,4),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p2')
			xlabel('time')
			ylabel('p2')

		end

		if dim == 3
			figure(101)

			subplot(311)
			plot(time, tmp_xpT(:,1),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x1')
			xlabel('time')
			ylabel('x1')

			subplot(312)
			plot(time, tmp_xpT(:,2),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x2')
			xlabel('time')
			ylabel('x2')

			subplot(313)
			plot(time, tmp_xpT(:,3),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x3')
			xlabel('time')
			ylabel('x3')

			figure(102)

			subplot(311)
			plot(time, tmp_xpT(:,4),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p1')
			xlabel('time')
			ylabel('p1')

			subplot(312)
			plot(time, tmp_xpT(:,5),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p2')
			xlabel('time')
			ylabel('p2')

			subplot(313)
			plot(time, tmp_xpT(:,6),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p3')
			xlabel('time')
			ylabel('p3')

		end

		if dim == 4

			figure(101)

			subplot(411)
			plot(time, tmp_xpT(:,1),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x1')
			xlabel('time')
			ylabel('x1')

			subplot(412)
			plot(time, tmp_xpT(:,2),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x2')
			xlabel('time')
			ylabel('x2')

			subplot(413)
			plot(time, tmp_xpT(:,3),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x3')
			xlabel('time')
			ylabel('x3')

			subplot(414)
			plot(time, tmp_xpT(:,4),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x4')
			xlabel('time')
			ylabel('x4')

			figure(102)

			subplot(411)
			plot(time, tmp_xpT(:,5),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p1')
			xlabel('time')
			ylabel('p1')

			subplot(412)
			plot(time, tmp_xpT(:,6),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p2')
			xlabel('time')
			ylabel('p2')

			subplot(413)
			plot(time, tmp_xpT(:,7),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p3')
			xlabel('time')
			ylabel('p3')

			subplot(414)
			plot(time, tmp_xpT(:,8),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p4')
			xlabel('time')
			ylabel('p4')

		end

		if dim == 5
			figure(101)

			subplot(511)
			plot(time, tmp_xpT(:,1),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x1')
			xlabel('time')
			ylabel('x1')

			subplot(512)
			plot(time, tmp_xpT(:,2),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x2')
			xlabel('time')
			ylabel('x2')

			subplot(513)
			plot(time, tmp_xpT(:,3),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x3')
			xlabel('time')
			ylabel('x3')

			subplot(514)
			plot(time, tmp_xpT(:,4),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x4')
			xlabel('time')
			ylabel('x4')

			subplot(515)
			plot(time, tmp_xpT(:,5),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - x5')
			xlabel('time')
			ylabel('x5')

			figure(102)

			subplot(511)
			plot(time, tmp_xpT(:,6),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p1')
			xlabel('time')
			ylabel('p1')

			subplot(512)
			plot(time, tmp_xpT(:,7),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p2')
			xlabel('time')
			ylabel('p2')

			subplot(513)
			plot(time, tmp_xpT(:,8),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p3')
			xlabel('time')
			ylabel('p3')

			subplot(514)
			plot(time, tmp_xpT(:,9),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p4')
			xlabel('time')
			ylabel('p4')

			subplot(515)
			plot(time, tmp_xpT(:,10),plotcolor,'LineWidth',plotwidth)
			hold on
			title('time - p5')
			xlabel('time')
			ylabel('p5')
		end
	end
end