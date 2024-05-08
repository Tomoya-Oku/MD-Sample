subroutine calc_VelVerlet
    use variables
    use parameters
    implicit none
	integer :: i
	double precision :: vene
	double precision, dimension(3) :: venes
    double precision, dimension(nkoss, 3) :: temp_vel
    double precision, dimension(nkoss) :: temp_poten

    ! 初期化
    for(:,:) = 0.0000D0
    poten(:) = 0.0000D0
    ukine(:) = 0.0000D0

    call calc_potential ! ポテンシャル計算

    ! 運動エネルギー計算
    do i = 1, nkoss
        venes(:) = vel(i,:) + for(i,:)*0.500D0*dt
        vene = venes(1)*venes(1) + venes(2)*venes(2) + venes(3)*venes(3)
        ukine(i) = 0.500D0 * zmass * vene
    end do

    do i = 1, nkoss
        temp_vel(i,:) = vel(i,:) + 0.500D0*for(i,:)*dt
        pos(i,:) = pos(i,:) + temp_vel(i,:)*dt
    end do

    ! 初期化
    for(:,:) = 0.0000D0
    poten(:) = 0.0000D0

    ! 再度ポテンシャル計算
    call calc_potential
    poten(:) = temp_poten(:) ! ポテンシャルのみ戻す

    do i = 1, nkoss
        vel(i,:) = temp_vel(i,:) + 0.500D0*for(i,:)*dt
    end do

end subroutine calc_VelVerlet