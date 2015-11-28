<div class="row">
    <?php
    $conference = $this->_viewBag['body'];
    $confId = $conference->getId();
    if(true) :?>
        <div class="panel panel-default col-md-12 margin-right">
            <div class="panel-body">
            <?php if(($conference->getOwner() === $_SESSION['username'])) :?>
                <a class="float-right btn btn-success col-sm-2 text-center"
                   href="/lecture/addLecture/<?= $conference->getId() ?>/add">Add lecture</a>
                <a class="margin-right float-right btn btn-danger col-lg-2 text-center"
                   href="/conference/manageAdmins/<?= $conference->getId() ?>">Manage Admins</a>
            <?php endif; ?>
            <?php if (in_array($_SESSION['username'], $conference->getAdmins()) || (\Mvc\App::getInstance()->isLogged() && ($conference->getOwner() === $_SESSION['username'])) || ($_SESSION['role'] == 'site administrator')/* || $_SESSION['role'] === 'conference administrator'*/) : ?>
            <a class="margin-right float-right btn btn-warning col-sm-1 text-center"
                   href="/conference/editConference/<?= $conference->getId() ?>/edit">Edit</a>
            <?php if(($conference->getOwner() === $_SESSION['username']) || $_SESSION['role'] == 'site administrator') : ?>
            <a class="margin-right float-right btn btn-danger col-sm-1 text-center"
                   href="/conference/discardConf/<?= $conference->getId() ?>/remove">Discard</a>
            <?php endif; ?>

            <?php endif; ?>
                <div class="block">
                    <a class="panel panel-primary col-sm-4 btn btn-default text-center"
                       href="#"><?= $conference->getName() ?></a>
                    <p>&nbsp;&nbsp;&nbsp;&nbsp;<i><?= $conference->getDescription() ?></i></p>
                </div>
                <div class="block margin-top">
                    <p><b>Start date:</b> <?= date_format(date_create($conference->getStart()), 'd F Y')?></p>
                    <p><b>End date:</b> <?= date_format(date_create($conference->getEnd()), 'd F Y') ?></p>
                    <p><b>Owner name:</b> <?= $conference->getOwner() ?></p>
                    <p><b>Venue name:</b> <?= $conference->getVenue() ?></p>
                    <?php if(!(count($conference->getAdmins()) < 1)) :?>
                        <p><b>Administrators: </b><?= implode(', ', $conference->getAdmins()) ?></p>
                    <?php endif; ?>
                    <?php if((count($conference->getAdmins()) < 1)) :?>
                        <p><i>No administrators registered at this point.</i></p>
                    <?php endif; ?>
                </div>
            </div>
            <?php if((\Mvc\App::getInstance()->isLogged())) :?>
                <?php \Mvc\FormViewHelper::init()
                    ->initLink()->setAttribute('href', "/conference/maxLectures/$confId")->setAttribute('class', 'margin-right float-right btn btn-info')->setValue('Max Lectures')->create()
                    ->render(); ?>
                <?php \Mvc\FormViewHelper::init()
                    ->initLink()->setAttribute('href', "/conference/lectures/$confId")->setAttribute('class', 'margin-right float-right btn btn-info')->setValue('Lectures')->create()
                    ->render(); ?>
            <?php endif; ?>
        </div>
    <?php endif; ?>
</div>

