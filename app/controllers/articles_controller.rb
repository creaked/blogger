class ArticlesController < ApplicationController
    include ArticlesHelper
    
    before_filter :require_login, except: [:index, :show]
    
    def require_login
        unless Author.count == 0 || current_user
            redirect_to root_path, :flash => {notice: "You are not logged in"}
        end
    end

    def index
        @articles = Article.all
    end
    
    def show
        @article = Article.find(params[:id])
        @comment = Comment.new
        @comment.article_id = @article.id
    end
    
    def new
        @article = Article.new
    end

    def create
        @article = Article.new(article_params)
        @article.save
        
        flash.notice = "Article '#{@article.title}' Created!"
    
        redirect_to article_path(@article)
    end
    
    def destroy
        @articles = Article.destroy(params[:id])
        
        flash.notice = "Article Deleted!"

        redirect_to articles_path(@article)
    end
    
    def edit
        @article = Article.find(params[:id])
    end
    
    def update
        @article = Article.find(params[:id])
        @article.update(article_params)
        
        flash.notice = "Article '#{@article.title}' Updated!"
        
        redirect_to articles_path(@article)
    end
    
    before_filter :redirect_cancel, only: [:create, :update]

    def redirect_cancel
        flash.notice = "Canceled!"
        redirect_to articles_path(@article) if params[:cancel]
    end
end
