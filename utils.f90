module utils

implicit none

interface print_matrix
    module procedure print_matrix_int4_assumed_shape, print_matrix_logical_assumed_shape, print_matrix_int4_explicit_shape
end interface

interface read_data
    module procedure read_data_1c, read_data_2c
end interface

contains

    ! ==================================================================
    ! print matrix of integers using assumed-shape dummy arrays
    !
    subroutine print_matrix_int4_assumed_shape(m)

    integer, intent(in), dimension(:,:) :: m
    integer         :: i

    do i = 1, size(m, 1)
        write(*,*) m(i,:)
    end do

    end subroutine

    ! ==================================================================
    ! print matrix of logicals using assumed-shape dummy arrays
    !
    subroutine print_matrix_logical_assumed_shape(m)

    logical, dimension(:,:) :: m
    integer                 :: i

    do i = 1, size(m, 1)
        write(*,*) m(i,:)
    end do

    end subroutine


    ! ==================================================================
    ! print matrix of integers using automatic dummy arrays
    !
    subroutine print_matrix_int4_explicit_shape(m, n, k)

    integer, intent(in), dimension(n, k)    :: m
    integer, intent(in)                     :: n, k
    integer    :: i

    do i = 1, n
        write(*,*) m(i, 1:k)
    end do

    end subroutine


    ! ==================================================================
    ! linspace(xmin, xmax, len) generates an 1-d array of doubles from
    ! xmin to xmax equally spaced.
    function linspace(xmin,xmax,length)

    implicit none
    real(8), intent(in)         :: xmin, xmax
    integer, intent(in)         :: length
    real(8), dimension(length)  :: linspace

    real(8)     :: dx
    integer     :: i

    dx = (xmax - xmin)/(length - 1)

    linspace = [(xmin + i*dx, i=0, length-1)]

    end function

    !==============================================================
    !arange(xmin,xmax,dx) generates an 1-d array of doubles from
    ! xmin to xmax equally spaced with a given interval

    function arange(xmin,xmax,step)

        implicit none
        real(8),intent(in) :: xmin,xmax,step
        integer :: length
        real(8),dimension(:), allocatable :: arange
        integer :: i

        length = ((int(xmax)-int(xmin))/int(step)) + 1

        allocate(arange(length))

        arange = [(xmin + i*step, i=0, length-1)]

    end function arange


    ! ==================================================================
    ! print_continue prints the word "continue" to the standard output
    ! and waits until "enter" is entered by the user.
    subroutine print_continue

    print*
    print*, "continue ..."
    read*

    end subroutine


    ! ==================================================================
    ! This subroutine reads data from a file. The file must contain only
    ! one column of real variables.
    subroutine read_data_1c(x, n)

    real(8), dimension(:), allocatable, intent(out) :: x
    integer, intent(out)                            :: n

    real(8), dimension(:), allocatable              :: oldx
    character (len=100)	    :: datafile
    integer                 :: state

    ! ask user the name of the file
    write(*,'(a)',advance="no") "Enter name of 1-column data file: "
    read(*,*) datafile

    ! open file to read
    open(50, file = datafile, action="read", status="old" )

    allocate(x(0)) ! size zero to start with?
    n = 0

    do
        allocate(oldx(n+1))
        oldx(1:n) = x(1:n)
        read(50, *, iostat=state) oldx(n+1)

        if (state < 0 ) exit
        n = n + 1

        deallocate( x )
        allocate( x(n) )
        x(1:n) = oldx(1:n)
        deallocate( oldx )
    end do

    close(50)

    end subroutine


    ! =============================================================
    ! This subroutine reads data from a file. The file must contain
    ! two columns of real values.

    subroutine read_data_2c(x, n)

    implicit none
    real(8), dimension(:,:), allocatable, intent(out)   :: x        ! array to fill data in
    integer, intent(out)                                :: n      ! number of readed points

    real(8), dimension(:,:), allocatable                :: oldx     ! auxiliady arrays
    character (len=50)      :: datafile
    integer                 :: state

    ! ask user the name of the file
    write(*,'(a)',advance="no") "Enter name of the 2-column data file: "
    read(*,*) datafile

    ! open file to read
    open(75,file=datafile,action="read",status="old")

    ! initialization
    if (allocated(x)) deallocate( x )
    allocate(x(0,0))
    n = 0

    do
        allocate(oldx(n+1, 2))
        oldx(1:n,:) = x(1:n,:)

        read(75,*,iostat = state) oldx(n+1,:)
        if (state < 0 ) exit
        n = n + 1

        deallocate(x)
        allocate(x(n,2))
        x(1:n,:) = oldx(1:n,:)  ! x = oldx doesn't work anymore (it used to)
        deallocate(oldx)
    end do

    close(75)

    end subroutine


end module
