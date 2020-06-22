program ElectroMagneticWave_2d

use utils
use nrtype

implicit none

real(dp)                          :: eps , mu , cvel ,beta ,alfa       !valor de epsilon , mu y la velocidad de la luz

real(8)                           :: Tmax = 40.d0  !maximo tiempo
integer                           :: M    ! Division del tiempo en M slots
real(8)                           :: dt           ! Diferencial de tiempo

real(8), parameter                :: L = 40.d0    ! longitud del contenedor unidimensional
integer, parameter                :: N = 999       ! tamaño de slots en el eje z
real(8)                           :: dz           ! Diferencial de posicion

real(8) , DIMENSION(1:N+2)        :: Enew,Eold 
real(8) , DIMENSION(0:N+1)        :: Hnew, Hold   !arrays auxiliares para el campo electrico y magneticop en step k y k+1
real(8) , DIMENSION(0:N+1)        :: x

real(8) , Dimension(0:N+1)        :: delta ! funcion delta y x auxiliar y desplazamiento de la delta
real(8)                           :: delt  

integer                           :: k , j        ! contadores para el posicion y tiempo 
real(8)                           :: Term_E, Term_H

dz = L/(Real(N,8) + 1.d0)

eps =  8.854187e-12_dp
mu = PI_D * 4.0e-7  
cvel = 1.d0/sqrt(eps*mu)

dt = dz/cvel
M = 1000

beta = dt*cvel/dz
alfa = sqrt(eps/mu)

x = linspace(0.d0, L , N + 2 ) 

Enew = 0.d0
Hnew = 0.d0

! 50 format({M+1}f20.10)
50 format(1001f20.10)

do j = 0 , M
    !export input data

    !open(30, file='temp1.txt')
    open(10,file = 'e_field.dat')
    open(20,file = 'h_field.dat')

    open(30, file = 'e_field.txt')
    open(40, file = 'h_field.txt')

    write(10,50) (Enew(k),k=1,N+2)
    write(20,50) (Hnew(k),k=0,N+1)

    write(30,50) (Enew(k),k=1,N+2)
    write(40,50) (Hnew(k),k=0,N+1)

    Eold(:) = Enew(:)
    Hold(:) = Hnew(:)

    do k = 2 , N+1

        Term_E = Eold(k) * alfa 
        Term_E = Term_E - beta*(Hold(k) - Hold(k-1))
        ! Term_E = Term_E - beta*dz*Eold(k)
        Enew(k) = Term_E / alfa

    end do

    ! Condiciones de Frontera del campo electrico
    Enew(1) = 15.d0*sin(2.d0*PI_D*Real(j,8)*20.d0/Real(M,8))

    if (j<=N+1) then
        Enew(N+2) = 0.d0        
    else
        Enew(N+2) = Enew(1) 
    end if

    ! if (j<=50) then 
    !     Enew(1) = 10.d0*sin(2.d0*PI_D*Real(j,8)*20.d0/Real(M,8))
    ! else 
    !     Enew(1) = Enew(2)
    ! end if

    do k = 1 , N+1

        Term_H = Hold(k)
        Term_H = Term_H - beta*alfa*(Enew(k+1) - Enew(k))
        Hnew(k) = Term_H

    end do

    ! Condiciones de Frontera del campo magnetico

    Hnew(0) = Hnew(1) ! condicion de dirichlet

    !Hnew(0) = 1.d0*sin(2.d0*PI_D*Real(j,8)*20.d0/Real(M,8))

    ! if (j<=N+1) then
    !     Hnew(N+1) = 0.d0        
    ! else
    !     Hnew(N+1) = Hnew(0) 
    ! end if
    ! Hnew(N+1) = Hnew(N)

end do

end program ElectroMagneticWave_2d