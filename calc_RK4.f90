function search_prox(obj) result(prox)
    use variables
    use parameters
    implicit none
    integer :: i, prox
    integer, allocatable :: min_is(:)
    double precision, dimension(3), intent(in) :: obj
    double precision, dimension(nkoss) :: distance

    ! positionから一番近い分子を探す
    do i = 1, nkoss
        distance(i) = (pos(i,1) - obj(1))**2 + (pos(i,2) - obj(2))**2 + (pos(i,3) - obj(3))**2
    end do

    min_is = minloc(distance)
    prox = min_is(1)
end function

subroutine calc_RK4
    use variables
    use parameters
    implicit none
    integer :: i, j, prox, search_prox
    double precision :: vene
    double precision, dimension(3) :: venes
    double precision, dimension(nkoss, 4, 3) :: k_pos
    double precision, dimension(nkoss, 4, 3) :: k_vel

    ! 初期化
    for(:,:) = 0.0000D0
    poten(:) = 0.0000D0
    ukine(:) = 0.0000D0

    ! ポテンシャル計算
    call calc_potential

    ! 運動エネルギー計算
    do i=1, nkoss
        venes(:) = vel(i,:) + for(i,:)*0.500D0*dt
        vene = venes(1)*venes(1) + venes(2)*venes(2) + venes(3)*venes(3)
        ukine(i) = 0.500D0 * zmass * vene
    end do

    ! RK4 Method
    do i = 1, nkoss
        k_pos(i, 1, :) = pos(i, :) + vel(i, :)*dt
        prox = search_prox(pos(i, :))
        k_vel(i, 1, :) = vel(i, :) + for(prox, :)*dt

        do j = 2,4
            k_pos(i, j, :) = pos(i, :) + (vel(i,:) + k_vel(i, j-1, :)) * 0.500D0 * dt
            prox = search_prox((pos(i,:) + k_pos(i, j-1, :)) * 0.500D0)
            k_vel(i, j, :) = vel(i, :) + for(prox,:) * dt
        end do

        pos(i,:) = dble(1.0/6.0) * (2*k_pos(i, 1, :) + k_pos(i, 2, :) + k_pos(i, 3, :) + 2*k_pos(i, 4, :))
        vel(i,:) = dble(1.0/6.0) * (2*k_vel(i, 1, :) + k_vel(i, 2, :) + k_vel(i, 3, :) + 2*k_vel(i, 4, :))
    end do

end subroutine calc_RK4