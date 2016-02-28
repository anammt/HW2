class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.order(params[:sort_by])
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
 
  def updatesuccess
  
    oldtitle = params[:oldTitle]["title"]
    newtitle = params[:updatedTitle]["newtitle"]
    newRating = params[:updatedRating]["rating"]
    newReleaseDay = params[:updatedDate]["release_date(3i)"]
    newReleaseMonth = params[:updatedDate]["release_date(2i)"]
    newReleaseYear = params[:updatedDate]["release_date(1i)"]
  
    if (oldtitle=="")||(newtitle=="")
      flash[:notice] = "Title feilds can't be empty!"
      redirect_to movies_updatenew_path
      
    elsif Movie.exists?(title: oldtitle)
      @movie = Movie.find_by title: oldtitle
      updatedDate = DateTime.parse(newReleaseYear+"-"+newReleaseMonth+"-"+newReleaseDay)
      @movie.update(title: newtitle,rating: newRating,release_date: updatedDate)
      flash[:notice] = "#{@movie.title} is updated."
      redirect_to movie_path(@movie)
    else
      render "notfound.html.haml"
      return
    end
  end
  
  def deletebyratingC 
     rating = params[:ratingdelete]["rating"]
    Movie.where(:rating => (rating)).destroy_all
    flash[:notice] = "Delete Successful"
    redirect_to movies_path
  end
  
  def deletebynameC
     movie = params[:movie]["title"]
    if (movie=="")
      flash[:notice] = "Select a Movie!"
      redirect_to movies_deletebyname_path
    elsif Movie.exists?(title: movie)
      Movie.where(:title => movie).destroy_all
      flash[:notice] = "Delete Successful"
      redirect_to movies_path
    else
      render "notfound.html.haml"
      return 
    end
  end
  
  
  
end
